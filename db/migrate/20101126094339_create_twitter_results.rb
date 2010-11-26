class CreateTwitterResults < ActiveRecord::Migration
  def self.up
    create_table :twitter_results do |t|
      t.integer :tweet_id
      t.text :tweet
      t.string :screen_name
      t.string :img_url
      t.datetime :tweet_date
      t.string :source
      t.string :keyword

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_results
  end
end
