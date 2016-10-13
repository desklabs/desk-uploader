# config/initializers/superworkers.rb
Dir['./app/workers/superworkers/*'].each { |f| require f }
Sidekiq::Superworker.options[:superjob_expiration] = 86400