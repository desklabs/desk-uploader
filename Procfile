web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -c 10 -e ${RAILS_ENV:-development} -C config/myapp_sidekiq.yml
#worker2: bundle exec sidekiq -c 10