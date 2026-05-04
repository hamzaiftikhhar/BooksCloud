# Auto-load constants, services, queries, and presenters
Rails.autoloaders.main.push_dir "app/constants"
Rails.autoloaders.main.push_dir "app/exceptions"
Rails.autoloaders.main.push_dir "app/services"
Rails.autoloaders.main.push_dir "app/queries"
Rails.autoloaders.main.push_dir "app/presenters"
