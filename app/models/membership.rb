class Membership < ActiveRecord::Base
  PRIVILEGE_CODES = { read: 'r', read_write: 'rw', read_write_execute: 'rwx' } # modeled after OS privilege codes
  VALID_PRIVILEGES = PRIVILEGE_CODES.values
  
  belongs_to :organization
  belongs_to :user
  belongs_to :creator, class_name: 'User' # Inviter of this person to this org
  
  attr_accessor :user_via_email # Allow membership to be added by email.
  
  validates :organization_id, presence: true, uniqueness: { scope: :user_id }
  validates :user, presence: { message: '- no user account found with that email.  Please have your friend signup for free, first!' }
  validates :privileges, presence: true, inclusion: { in: VALID_PRIVILEGES, message: "%{value} setting is not valid." }
  validates :creator, presence: true
  
  before_validation :set_user_via_email
  
  def set_user_via_email
    return true unless self.user.nil?
    self.user = User.find_by_email(self.user_via_email)
  end
  
  
  # Can read only in this org, and not do anything.
  def read?
    self.privileges == PRIVILEGE_CODES[:read] || self.write?
  end
  
  # Can do stuff within this org
  def write?
    self.privileges == PRIVILEGE_CODES[:read_write] || self.execute?
  end
  
  # Can admin everything in this org
  def execute?
    self.privileges == PRIVILEGE_CODES[:read_write_execute]
  end
  
  def creator_of_org?
    !self.organization.creator_id.to_s.blank? && !self.user_id.to_s.blank? && self.organization.creator_id.to_s == self.user_id.to_s
  end
end
