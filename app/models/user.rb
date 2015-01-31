class User < ActiveRecord::Base
  has_many :org_user_privileges
  has_many :created_organizations, class_name: 'Organization', foreign_key: 'creator_id'
  has_many :created_org_user_privileges, class_name: 'OrgUserPrivilege', foreign_key: 'creator_id'
  
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
end
