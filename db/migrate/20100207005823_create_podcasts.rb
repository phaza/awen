class CreatePodcasts < ActiveRecord::Migration
  def self.up
    create_table :podcasts do |t|
      t.string :mime
      t.string :title
      t.string :description
      t.string :url
      t.string :path
      t.datetime :published_at
      t.string :duration
      t.string :guid
      t.references :podcast_subscription

      t.timestamps
    end
  end

  def self.down
    drop_table :podcasts
  end
end
