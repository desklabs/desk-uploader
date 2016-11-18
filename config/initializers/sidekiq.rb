require 'autoscaler/sidekiq'
require 'autoscaler/heroku_platform_scaler'
require 'autoscaler/linear_scaling_strategy'

# Sidekiq.configure_client do |config|
#   config.client_middleware do |chain|
#     heroku = Autoscaler::HerokuPlatformScaler.new
#     chain.add Autoscaler::Sidekiq::Client, 'files'=>heroku, 'rows'=>heroku, 'default'=>heroku
#   end
# end


# Sidekiq.configure_server do |config|
#   config.server_middleware do |chain|
#     chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuPlatformScaler.new, 60) # 60 second timeout
#   end
# end


  Sidekiq.configure_client do |config|
    config.client_middleware do |chain|
      heroku   = Autoscaler::HerokuPlatformScaler.new
      strategy = Autoscaler::DelayedShutdown.new(
        Autoscaler::LinearScalingStrategy.new(5, 25),
        60
      )
      Autoscaler::Sidekiq::Client
        .add_to_chain(chain, 'files'=>heroku, 'rows'=>heroku, 'default'=>heroku)
        .set_initial_workers(strategy)
    end
  end

  Sidekiq.configure_server do |config|
    config.server_middleware do |chain|
      strategy = Autoscaler::DelayedShutdown.new(
        Autoscaler::LinearScalingStrategy.new(5, 25),
        60
      )
      chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuPlatformScaler.new, strategy)
    end
  end