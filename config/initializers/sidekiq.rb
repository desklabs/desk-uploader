require 'autoscaler/sidekiq'
require 'autoscaler/heroku_platform_scaler'
require 'autoscaler/linear_scaling_strategy'


if ENV['HEROKU_API_KEY'] and ENV['HEROKU_APP']
  Sidekiq.configure_client do |config|
    config.client_middleware do |chain|
      heroku   = Autoscaler::HerokuPlatformScaler.new
      strategy = Autoscaler::DelayedShutdown.new(
        Autoscaler::LinearScalingStrategy.new(5, ENV['SIDEKIQ_CONCURRENCY']),
        10
      )
      Autoscaler::Sidekiq::Client
      .add_to_chain(chain, 'files'=>heroku, 'rows'=>heroku, 'default'=>heroku)
      .set_initial_workers(strategy)
    end
  end

  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      strategy = Autoscaler::DelayedShutdown.new(
        Autoscaler::LinearScalingStrategy.new(5, ENV['SIDEKIQ_CONCURRENCY']),
        10
      )
      chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuPlatformScaler.new, strategy)
    end
  end
end
