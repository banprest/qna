require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :microsoft
  
  #Подскажите пожалуйста не могу подключть облачный сервис. В консоле:
  #Started POST "/rails/active_storage/direct_uploads" for ::1 at 2021-03-13 19:26:08 +0300
  #Processing by ActiveStorage::DirectUploadsController#create as JSON
  #Parameters: {"blob"=>{"filename"=>"car.rb", "content_type"=>"application/x-ruby", "byte_size"=>4141, "checksum"=>"jFnIczwFUT9HjmBKbPue6w=="}, "direct_upload"=>{"blob"=>{"filename"=>"car.rb", "content_type"=>"application/x-ruby", "byte_size"=>4141, "checksum"=>"jFnIczwFUT9HjmBKbPue6w=="}}}
  #TRANSACTION (8.1ms)  BEGIN
  #ActiveStorage::Blob Create (1.1ms)  INSERT INTO "active_storage_blobs" ("key", "filename", "content_type", "service_name", "byte_size", "checksum", "created_at") VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING "id"  [["key", "9eageuyd0033r4unsgks3wprsa0u"], ["filename", "car.rb"], ["content_type", "application/x-ruby"], ["service_name", "microsoft"], ["byte_size", 4141], ["checksum", "jFnIczwFUT9HjmBKbPue6w=="], ["created_at", "2021-03-13 16:26:08.847400"]]
  #TRANSACTION (1.5ms)  COMMIT
  #AzureStorage Storage (0.9ms) Generated URL for file at key: 9eageuyd0033r4unsgks3wprsa0u (https://qna.blob.core.windows.net/banprest/9eageuyd0033r4unsgks3wprsa0u?sp=rw&sv=2018-11-09&se=2021-03-13T16%3A31%3A08Z&sr=b&sig=1iHDVa89%2BGWzVIlOtOYAmrFhr3ERvLCDcibY%2FKjifl4%3D)
  #Completed 200 OK in 148ms (Views: 0.3ms | ActiveRecord: 17.3ms | Allocations: 48130)
  #По ссылке:
  #<Code>BlobNotFound</Code>
  #<Message>The specified blob does not exist. RequestId:6e37515d-b01e-000c-4d25-18e40e000000 Time:2021-03-13T16:26:15.0427164Z</Message>


  config.require_master_key = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
end
