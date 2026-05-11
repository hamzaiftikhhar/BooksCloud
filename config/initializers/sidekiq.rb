# Load Cron Jobs into Sidekiq

require "sidekiq"
require "sidekiq-cron"

# server
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://localhost:6379/0" }

  schedule_file = Rails.root.join("config/schedule.yml")

  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end
end

# client
Sidekiq.configure_client do |config|
  config.redis = { url: "redis://localhost:6379/0" }
end
