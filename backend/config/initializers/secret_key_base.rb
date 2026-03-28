# In development/test, use a hardcoded key; in production, use the env var
Rails.application.config.secret_key_base = ENV.fetch("SECRET_KEY_BASE") {
  if Rails.env.production?
    raise "SECRET_KEY_BASE is required in production"
  else
    "dev_secret_key_base_for_development_only_not_for_production_use"
  end
}
