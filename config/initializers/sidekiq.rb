require 'sidekiq-cron'

Sidekiq.configure_server do |config|
    config.redis = { url: ENV.fetch('REDISCLOUD_URL', nil) }
    config.logger.level = Logger::INFO
    schedule_file = "config/schedule.yml"
    if File.exist?(schedule_file) && Sidekiq.server?
        Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
end