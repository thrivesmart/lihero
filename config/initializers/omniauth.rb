require 'linkedin_search'
Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user:email,read:org"
  provider :linkedin, ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'], scope: LinkedinSearch::LINKEDIN_SCOPE
end

OmniAuth.config.logger = Rails.logger
