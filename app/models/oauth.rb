class Oauth < ActiveRecord::Base
  belongs_to :user
  
  validates :account, uniqueness: { scope: [:kind, :user_id] }, presence: true
  validates :secret, presence: true
  validates :token, presence: true
  validates :user, presence: true
  
  def linkedin_access_token
    @linkedin_access_token ||= begin
      li = LinkedIn::Client.new(LINKEDIN_OAUTH[:api_key], LINKEDIN_OAUTH[:secret_key])
      li.authorize_from_access(self.token, self.secret)
      li
    end
  end
end
