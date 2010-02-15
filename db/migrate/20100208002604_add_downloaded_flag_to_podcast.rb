class AddDownloadedFlagToPodcast < ActiveRecord::Migration
  def self.up
    add_column :podcasts, :downloaded, :boolean, :default => false, :null => :false
  end

  def self.down
    remove_column :podcasts, :downloaded
  end
end
