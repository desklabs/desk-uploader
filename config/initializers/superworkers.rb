# config/initializers/superworkers.rb
Dir['./app/workers/superworkers/*'].each { |f| require f }
