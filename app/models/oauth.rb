class Oauth < ActiveRecord::Base
  belongs_to :user
  
  validates :account, uniqueness: { scope: [:kind, :user_id] }, presence: true
  # validates :secret, presence: true ## Linkedin doesn't seem to be populating this...
  validates :token, presence: true
  validates :user, presence: true
  
  def linkedin_access_token
    @linkedin_access_token ||= begin
      li = LinkedIn::Client.new(ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET'])
      li.authorize_from_access(self.token, self.secret)
      li
    end
  end
end
