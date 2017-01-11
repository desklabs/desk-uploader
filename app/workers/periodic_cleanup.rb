class PeriodicCleanup

  include Sidekiq::Worker
  sidekiq_options queue: 'system'

  def perform()
    puts "Performing periodic cleanup"

    if Sidekiq::Queue.new("rows").size + Sidekiq::Queue.new("files").size + Sidekiq::RetrySet.new.size + Sidekiq::ScheduledSet.new.size > 0
      puts "Jobs still in queue, exiting."
      return
    else
      puts "Beginning cleanup."
      User.all.destroy
      if Row.count > 0
        Row.all.destroy
      end
    end
  end
end
