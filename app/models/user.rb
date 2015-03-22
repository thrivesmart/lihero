class User < ActiveRecord::Base
  has_many :memberships
  has_many :organizations, through: :memberships
  has_many :created_organizations, class_name: 'Organization', foreign_key: 'creator_id'
  has_many :created_memberships, class_name: 'Membership', foreign_key: 'creator_id'
  has_many :oauths
  
  def to_param
    self.linkedinid
  end
  
  def self.create_or_update_user_from_omniauth(omniauth_auth)
    existing_user = User.find_by_linkedinid(omniauth_auth['uid'])
    if existing_user
      existing_user.update_attributes(
        email:           omniauth_auth['info']['email']
      )
    else
      existing_user = User.create(
        linkedinid:      omniauth_auth['uid'],
        email:           omniauth_auth['info']['email'],
        first_name:      omniauth_auth['info']['name'].partition(" ").first.partition(" ").first,
        middle_name:     omniauth_auth['info']['name'].partition(" ").first.partition(" ").last,
        last_name:       omniauth_auth['info']['name'].rpartition(" ").last
      )
    end
    
    # linkedin_client = LinkedIn::Client.new ENV['LINKEDIN_KEY'], ENV['LINKEDIN_SECRET']
    # request_token = linkedin_client.request_token({}, :scope => LinkedinSearch::LINKEDIN_SCOPE)
    existing_user.create_or_update_single_oauth!('linkedin', omniauth_auth['uid'], omniauth_auth['credentials']['token'], omniauth_auth['credentials']['secret'].to_s)
    existing_user
  end
  
  def full_name
    "#{self.first_name}#{self.middle_name.blank? ? '' : ' '+self.middle_name} #{self.last_name}"
  end
  
  def default_linkedin_oauth
    self.oauths.where(kind: 'linkedin').first
  end
  
  def create_or_update_single_oauth!(kind, account, token, secret)
    new_or_existing_oauth = self.oauths.where(kind: kind, account: account.downcase).first
    unless new_or_existing_oauth
      self.oauths.create!(kind: kind, secret: secret, token: token, account: account.downcase)
    else
      new_or_existing_oauth.update_attributes!(secret: secret, token: token)
    end
  end
end
