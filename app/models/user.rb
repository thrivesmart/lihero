class User < ActiveRecord::Base
  has_many :memberships
  has_many :organizations, through: :memberships
  has_many :created_organizations, class_name: 'Organization', foreign_key: 'creator_id'
  has_many :created_memberships, class_name: 'Membership', foreign_key: 'creator_id'
  
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
        linkedinid:        omniauth_auth['uid'],
        email:           omniauth_auth['info']['email'],
        first_name:      omniauth_auth['info']['name'].partition(" ").first.partition(" ").first,
        middle_name:     omniauth_auth['info']['name'].partition(" ").first.partition(" ").last,
        last_name:       omniauth_auth['info']['name'].rpartition(" ").last
      )
    end
    existing_user
  end
  
  def full_name
    "#{self.first_name}#{self.middle_name.blank? ? '' : ' '+self.middle_name} #{self.last_name}"
  end
end
