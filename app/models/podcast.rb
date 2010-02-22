class Podcast < ActiveRecord::Base
  
  belongs_to :podcast_subscription
  
  # validates_uri_existence_of :url
  validates_presence_of :mime
  validates_uniqueness_of :guid
  
  before_destroy :cleanup
  
  def download
    _download(self.url)
  end
  
  def progress
    return 100.0 if self.downloaded
    Rails.cache.read(download_cache_key).to_f
  end
  
  private
  def download_cache_key
    "download-progress-#{self.id}"
  end
  
  def cleanup
    FileUtils.rm(self.path) if self.path
  end
  
  def _progress(p)
    Rails.logger.debug [p, @prev_progress].inspect
    Rails.cache.write(download_cache_key, p.to_i, :expires_in => 15.seconds) if p.to_i != @prev_progress.to_i
    
    @prev_progress = p.to_i
  end
  
  def _download(_url, i = 0)
    return if i > 9
    
    parsed_url = URI.parse(_url)
    _path = "#{self.podcast_subscription.path}/#{File.basename(parsed_url.path)}"
    
    Net::HTTP.start(parsed_url.host, parsed_url.port) do |http|
      http.request_get(parsed_url.request_uri) do |res|
        
        if res.is_a? Net::HTTPRedirection
          _download(res.get_fields('location').first, i+1)
          return
        end
        
        FileUtils.mkdir_p(File.dirname(_path)) unless File.exists?(File.dirname(_path))
        
        open(_path, 'w') do |file|

          res.read_body do |fragment|
            file.write(fragment)
            _progress((file.tell.to_f / res.content_length) * 100.0)
          end

        end

        if File.exists?(_path) && File.size(_path) == res.content_length
          write_attribute(:path, _path)
          write_attribute(:downloaded, true)
          self.save
        end

      end
    end
  end
  
end
