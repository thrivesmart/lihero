Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user:email,read:org"
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'], scope: 'r_emailaddress r_contactinfo r_network r_fullprofile'
end

OmniAuth.config.logger = Rails.logger
