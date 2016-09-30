class WorkerStart

  include Sidekiq::Worker

  def perform()
    puts "worker start"
  end

end
