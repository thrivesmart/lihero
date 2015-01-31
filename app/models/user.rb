class User < ActiveRecord::Base
  
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
        first_name:      omniauth_auth['info']['name'].rpartition(" ").first.rpartition(" ").first,
        middle_name:     omniauth_auth['info']['name'].rpartition(" ").first.rpartition(" ").last,
        last_name:       omniauth_auth['info']['name'].rpartition(" ").last
      )
    end
    existing_user
  end
end
