Settings.defaults[:media_folder]    = "#{RAILS_ROOT}/media"
Settings.defaults[:music_folder]    = "#{Settings.media_folder}/music"
Settings.defaults[:video_folder]    = "#{Settings.media_folder}/video"
Settings.defaults[:podcast_folder]  = "#{Settings.media_folder}/podcast"

FileUtils.makedirs Settings.music_folder unless File.exists? Settings.music_folder
FileUtils.makedirs Settings.video_folder unless File.exists? Settings.video_folder
FileUtils.makedirs Settings.podcast_folder unless File.exists? Settings.podcast_folder
