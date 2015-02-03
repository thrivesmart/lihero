class Organization < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :permalink, presence: true, uniqueness: { case_sensitive: false }
  validates :creator, presence: true  
  
  before_validation :autofill_permalink_if_blank
  
  after_create :create_default_membership
  
  def to_param
    self.permalink
  end
  
  def create_default_membership
    self.memberships.create!(
      user: self.creator,
      privileges: Membership::PRIVILEGE_CODES[:read_write_execute],
      creator: self.creator
    )
  end
  
  def autofill_permalink_if_blank
    return true unless self.permalink.blank? # Bypass if permalink is already set
    self.permalink = AutoPermalink::cleaned_deduped_permalink(self, self.name)
  end
  
  
end
