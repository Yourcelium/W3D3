class CreateUniqueLongUrlUserPair < ActiveRecord::Migration[5.1]
  def change
    add_index :shortened_urls, [:long_url, :user_id], unique: true
    add_index :shortened_urls, [:short_url, :long_url], unique: true  
  end
end
