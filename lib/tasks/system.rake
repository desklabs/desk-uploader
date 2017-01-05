namespace :system do
  desc "TODO"
  task cleanup: :environment do
    PeriodicCleanup.perform_async
  end

end
