class Lead < ActiveRecord::Base
  KINDS = ['person', 'company']
  
  belongs_to :list
  belongs_to :creator, class_name: 'User' # Creator of this list
  
  attr_accessor :search_query
  
  validates :list, presence: true
  validates :creator, presence: true
  validates :linkedinid, presence: true, uniqueness: { scope: :list_id }
  validates :kind, presence: true, inclusion: { in: KINDS, message: "%{value} kind is not valid." }
  validates :name, presence: true
end
