class CreatePodcastSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :podcast_subscriptions do |t|
      t.string :title
      t.string :image
      t.string :description
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :podcast_subscriptions
  end
end
