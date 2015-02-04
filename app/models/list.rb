class List < ActiveRecord::Base
  belongs_to :organization
  belongs_to :creator, class_name: 'User' # Creator of this list
  
  
  validates :organization, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :organization_id }
  validates :permalink, presence: true, uniqueness: { case_sensitive: false }
  validates :creator, presence: true
  
  before_validation :autofill_permalink_if_blank
  
  def to_param
    self.permalink
  end
  
  def autofill_permalink_if_blank
    return true unless self.permalink.blank? # Bypass if permalink is already set
    self.permalink = AutoPermalink::cleaned_deduped_permalink(self, self.name)
  end
  
end
