class AutoscalerPing
  include Sidekiq::Worker
  def perform()
    puts "pinging autoscaler"
  end
end
