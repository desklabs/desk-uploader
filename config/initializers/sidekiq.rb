require 'autoscaler/sidekiq'
#require 'autoscaler/heroku_platform_scaler'
require 'autoscaler/linear_scaling_strategy'

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    heroku = Autoscaler::LinearScalingStrategy.new(5,2)
    chain.add Autoscaler::Sidekiq::Client, 'files'=>heroku, 'rows'=>heroku, 'default'=>heroku
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    heroku = Autoscaler::LinearScalingStrategy.new(5,2)
    chain.add(Autoscaler::Sidekiq::Server, heroku, 60) # 60 second timeout
  end
end
