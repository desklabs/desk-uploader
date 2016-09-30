class WorkerEnd

  include Sidekiq::Worker

  def perform()
    puts "worker end"
  end

end
