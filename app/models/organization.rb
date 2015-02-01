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
    # Bypass if permalink is already set
    return true unless self.permalink.blank?
    
    self.permalink = self.class.cleaned_deduped_permalink(self.name)
  end
  
  
  def self.cleaned_permalink(str)
    # Not especially nice, but other things (like PermalinkFu plugin and iconv
    # in general) didn't work properly (some chars were incorrectly converted to
    # '-'
    permalink = str.dup.downcase
    permalink = permalink.strip
    permalink.gsub!(/[\/\.\:\@]/, " ")
    permalink.gsub!(/[àáâãäåāăÀÁÂÃÄÅĀĂ]/, 'a')
    permalink.gsub!(/æÆ/, 'ae')
    permalink.gsub!(/[ďđĎĐ]/, 'd')
    permalink.gsub!(/[çćčĉċÇĆČĈĊ]/, 'c')
    permalink.gsub!(/[èéêëēęěĕėÈÉÊËĒĘĚĔĖ]/, 'e')
    permalink.gsub!(/ƒƑ/, 'f')
    permalink.gsub!(/[ĝğġģĜĞĠĢ]/, 'g')
    permalink.gsub!(/[ĥħĤĦ]/, 'h')
    permalink.gsub!(/[ììíîïīĩĭÌÌÍÎÏĪĨĬ]/, 'i')
    permalink.gsub!(/[įıĳĵĮIĲĴ]/, 'j')
    permalink.gsub!(/[ķĸĶĸ]/, 'k')
    permalink.gsub!(/[łľĺļŀŁĽĹĻĿ]/, 'l')
    permalink.gsub!(/[ñńňņŉŋÑŃŇŅŉŊ]/, 'n')
    permalink.gsub!(/[òóôõöøōőŏŏÒÓÔÕÖØŌŐŎŎ]/, 'o')
    permalink.gsub!(/œŒ/, 'oe')
    permalink.gsub!(/ąĄ/, 'q')
    permalink.gsub!(/[ŕřŗŔŘŖ]/, 'r')
    permalink.gsub!(/[śšşŝșŚŠŞŜȘ]/, 's')
    permalink.gsub!(/[ťţŧțŤŢŦȚ]/, 't')
    permalink.gsub!(/[ùúûüūůűŭũųÙÚÛÜŪŮŰŬŨŲ]/, 'u')
    permalink.gsub!(/ŵŴ/, 'w')
    permalink.gsub!(/[ýÿŷÝŸŶ]/, 'y')
    permalink.gsub!(/[žżźŽŻŹ]/, 'z')
    permalink.gsub!(/[^a-z0-9_-]/i, '-')
    permalink.gsub!(/_+/, '_')
    permalink.gsub!(/ +/, '-')
    permalink.gsub!(/^-+/, '')
    permalink.gsub!(/-+/, '-')
    permalink
  end
  
  # Autofix duplication of permalinks
  def self.cleaned_deduped_permalink(candidate_permalink)
    candidate_permalink = cleaned_permalink(candidate_permalink)
    n = where(permalink: candidate_permalink).count

    if n > 0
      links = where(["permalink LIKE ?", "#{candidate_permalink}%"]).order(:id)

      number = 0

      links.each_with_index do |link, index|
        if link.permalink =~ /#{candidate_permalink}-\d*\.?\d+?$/
          new_number = link.permalink.match(/-(\d*\.?\d+?)$/)[1].to_i
          number = new_number if new_number > number
        end
      end
      return resolve_duplication(candidate_permalink, number + 1)
    else
      return candidate_permalink
    end
  end

  def self.resolve_duplication(permalink, number)
    "#{permalink}-#{number}"
  end
end
