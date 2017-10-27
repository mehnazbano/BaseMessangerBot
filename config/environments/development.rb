Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  dalli_config = YAML.load_file("#{Rails.root}/config/dalli.yml") rescue raise('dalli.yml missing. Are you serious about this?')
  config.cache_store = :dalli_store, dalli_config["host"], { namespace: dalli_config['namespace'], compress: true }
  # Don't care if the mailer can't send.
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :letter_opener


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log
  # React configurations
  config.react.variant = :development
  config.react.addons = true

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load
  routes.default_url_options = { host: "localhost", port: 3000 }
  Paperclip.options[:command_path] = "/Users/mehnazbano/"

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.assets.compress = false
  config.assets.enabled = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true
  EmailVerifier.config do |config|
    config.verifier_email = "realname@realdomain.com"
  end

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
