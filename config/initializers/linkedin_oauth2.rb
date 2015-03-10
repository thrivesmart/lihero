LinkedIn.configure do |config|
  config.client_id     = ENV["LINKEDIN_KEY"]
  config.client_secret = ENV["LINKEDIN_SECRET"]

  # This must exactly match the redirect URI you set on your application's
  # settings page. If your redirect_uri is dynamic, pass it into
  # `auth_code_url` instead.
  config.redirect_uri  = "http://www.lihero.io/auth/linkedin/callback"
end