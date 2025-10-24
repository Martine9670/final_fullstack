# config/environments/development.rb

require "active_support/core_ext/integer/time"

Rails.application.configure do
  # 🌶️ Auto-reload du code sans redémarrer le serveur
  config.enable_reloading = true

  # 💡 Ne charge pas tout le code au démarrage
  config.eager_load = false

  # 👀 Affiche les erreurs complètes
  config.consider_all_requests_local = true

  # ⏱️ Active le server timing
  config.server_timing = true

  # 🚀 Caching local (désactivé par défaut)
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
  end

  # 🧠 Stockage local pour ActiveStorage
  config.active_storage.service = :local

  # 💌 === CONFIGURATION MAILER ===

  # Utilise Gmail en mode SMTP (ou `letter_opener` en plan B)
  if ENV["USE_LETTER_OPENER"] == "true"
    # Mode démo : les mails s’ouvrent dans le navigateur
    config.action_mailer.delivery_method = :letter_opener
  else
    # Mode réel : envoi via SMTP Gmail
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              "smtp.gmail.com",
      port:                 587,
      domain:               "gmail.com", # ou ton propre domaine (ex: "finalfullstack.fr")
      authentication:       "plain",
      enable_starttls_auto: true,
      user_name:            ENV["GMAIL_USERNAME"],
      password:             ENV["GMAIL_PASSWORD"]
    }
  end

  # Active l’envoi des mails
  config.action_mailer.perform_deliveries = true

  # Affiche les erreurs d’envoi dans la console/log
  config.action_mailer.raise_delivery_errors = true

  # Indique l’hôte utilisé dans les liens des mails
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }

  # 💬 Logs et erreurs
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.active_job.verbose_enqueue_logs = true
  config.action_controller.raise_on_missing_callback_actions = true
  config.action_view.annotate_rendered_view_with_filenames = true
end
