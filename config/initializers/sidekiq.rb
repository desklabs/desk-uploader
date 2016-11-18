require 'autoscaler/sidekiq'
require 'autoscaler/heroku_platform_scaler'
require 'autoscaler/linear_scaling_strategy'


if ENV['HEROKU_ACCESS_TOKEN'] and ENV['HEROKU_APP']
  Sidekiq.configure_client do |config|
    config.client_middleware do |chain|
      heroku   = Autoscaler::HerokuPlatformScaler.new
      strategy = Autoscaler::DelayedShutdown.new(
        Autoscaler::LinearScalingStrategy.new(ENV['MAX_WORKERS'].to_i, ENV['SIDEKIQ_CONCURRENCY'].to_i),
        10
      )

      chain.add Autoscaler::Sidekiq::Client,'files'=>heroku, 'rows'=>heroku, 'default'=>heroku
      chain.add Autoscaler::Sidekiq::Client, strategy=> heroku

      # chain.add(Autoscaler::Sidekiq::Client
      # .add_to_chain(chain, 'files'=>heroku, 'rows'=>heroku, 'default'=>heroku)
      # .set_initial_workers(strategy)
    end
  end

  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      strategy = Autoscaler::DelayedShutdown.new(
        Autoscaler::LinearScalingStrategy.new(ENV['MAX_WORKERS'].to_i, ENV['SIDEKIQ_CONCURRENCY'].to_i),
        10
      )
      chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuPlatformScaler.new, strategy)
    end
  end
end
