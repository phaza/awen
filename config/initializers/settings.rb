Settings.defaults[:media_folder]    = "#{RAILS_ROOT}/media"
Settings.defaults[:incoming_folder] = "#{Settings.media_folder}/incoming"
Settings.defaults[:music_folder]    = "#{Settings.media_folder}/music"
Settings.defaults[:video_folder]    = "#{Settings.media_folder}/video"
Settings.defaults[:podcast_folder]  = "#{Settings.media_folder}/podcast"

Settings.defaults.find_all{|k, v| k.to_s.include? 'folder'}.each do |setting, folder|
  FileUtils.makedirs folder unless File.exists? folder
end
