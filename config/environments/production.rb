Myflix::Application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false
  Rails.application.routes.default_url_options[:host] = 'my-flix-app.herokuapp.com'
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  
  # Raven.configure do |config|
  #   config.dsn = 'https://30ca1b36aedd4e93bbf16e22531fddf5:2710cac194d14a47a2705fed90d40614@sentry.io/662424'
  # end
end
