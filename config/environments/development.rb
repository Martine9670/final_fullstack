require "active_support/core_ext/integer/time"

Rails.application.configure do
  # 🌶️ Auto-reload code without restarting the server
  config.enable_reloading = true

  # 💡 Do not load all code at startup
  config.eager_load = false

  # 👀 Show full error reports
  config.consider_all_requests_local = true

  # ⏱️ Enable server timing
  config.server_timing = true

  # 🚀 Local caching (disabled by default)
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
  end

  # 🧠 Local storage for ActiveStorage
  config.active_storage.service = :local

  # 💌 === MAILER CONFIGURATION ===

  # Use Gmail in SMTP mode (or `letter_opener` as a fallback)
  if ENV["USE_LETTER_OPENER"] == "true"
    # Demo mode: emails open directly in the browser
    config.action_mailer.delivery_method = :letter_opener
  else
    # Production mode: send emails via Gmail SMTP
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              "smtp.gmail.com",
      port:                 587,
      domain:               "gmail.com", # or your own domain (e.g. "finalfullstack.fr")
      authentication:       "plain",
      enable_starttls_auto: true,
      user_name:            ENV["GMAIL_USERNAME"],
      password:             ENV["GMAIL_PASSWORD"]
    }
  end

  # Enable email delivery
  config.action_mailer.perform_deliveries = true

  # Show email delivery errors in console/log
  config.action_mailer.raise_delivery_errors = true

  # Define the host used in email links
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # 💬 Logs and errors
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.active_job.verbose_enqueue_logs = true
  config.action_controller.raise_on_missing_callback_actions = true
  config.action_view.annotate_rendered_view_with_filenames = true

  # Allow local hosts for development
  config.hosts << "localhost"
  config.hosts << "127.0.0.1"

end
