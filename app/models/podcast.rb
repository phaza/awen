class Podcast
  include MongoMapper::Document
  # include ActiveModel::Validations
  
  plugin Joint
  
  attachment :file
  
  key :mime, String, :required => true
  key :title, String
  key :description, String
  key :url, String, :unique => true
  key :duration, String
  key :guid, String, :unique => true
  key :downloaded, Boolean, :default => false
  key :published_at, Time
  
  
  key :podcast_subscription_id, ObjectId
  belongs_to :podcast_subscription
  
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
  
  def _progress(p)
    Rails.cache.write(download_cache_key, p.to_i, :expires_in => 15.seconds) if p.to_i != @prev_progress.to_i
    
    @prev_progress = p.to_i
  end
  
  def _download(_url, i = 0)
    return if i > 9
    
    parsed_url = URI.parse(_url)
    filename = "#{File.basename(parsed_url.path)}"
  
    Net::HTTP.start(parsed_url.host, parsed_url.port) do |http|
      http.request_get(parsed_url.request_uri) do |res|
        
        if res.is_a? Net::HTTPRedirection
          _download(res.get_fields('location').first, i+1)
          return
        end
        
        tmp_file = Tempfile.open(filename)
            
        res.read_body do |fragment|
          tmp_file.write(fragment)
          _progress((tmp_file.tell.to_f / res.content_length) * 100.0)
        end        
        
        tmp_file.rewind
        self.file = tmp_file
        self['file_name'] = filename
        self.downloaded = true
        self.save
      
      end
      
    end
  end
  
end
