namespace :autoscaler do
  desc "TODO"
  task ping: :environment do
    AutoscalerPing.perform_async()
  end

end
