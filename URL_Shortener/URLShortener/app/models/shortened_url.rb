# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  short_url  :string           not null
#  long_url   :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :user_id, presence: true
  
  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
    
  has_many :visits, 
    primary_key: :id, 
    foreign_key: :shortened_url_id, 
    class_name: :Visit
  
  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user 
    
  def self.random_code
    random_string = SecureRandom::urlsafe_base64
    while ShortenedUrl.exists?(:short_url => random_string)
      random_string = SecureRandom::urlsafe_base64
    end
    random_string
  end
  
  def self.create!(user, long_url_str)
    ShortenedUrl.create(user_id: user.id, long_url: long_url_str, short_url: ShortenedUrl.random_code)
  end 
  
  def num_clicks
    self.visits.count
  end 
  
  def num_uniques 
    self.visitors.count
  end 
  
  def num_recent_uniques
    self.visitors.where(created_at > 10.minutes.ago).count
  end 
  
  
end
