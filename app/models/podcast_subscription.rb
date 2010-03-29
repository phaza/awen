class PodcastSubscription
  include MongoMapper::Document
  
  key :title, String
  key :image, String
  key :description, String
  key :url, String, :unique => true
  
  many :podcasts, :dependent => :destroy
  
  # validates :url, :url => true, :uniqueness => true
  # validates :url, :url => true
  
  after_create :delayed_selfupdate
    
  def delayed_selfupdate
    self.send_later(:parse)
    self.send_later(:download_episodes)
  end
  
  def parse
    doc = get_xml_doc
    _title = doc.search('channel > title').inner_text
    _description = doc.search('channel > description').inner_text
    _description = doc.search('channel > itunes|summary').inner_text if _description.blank?
    _image = doc.search('channel > itunes|image').first['href']
    _image = doc.search('channel > image url').inner_text unless _image =~ /\.(jpg|png)$/
    
    new_feed_url = doc.search('channel > itunes|new-feed-url').inner_text
    
    write_attribute(:url, new_feed_url) unless new_feed_url.blank?
    
    self.description =  _description
    self.title = _title
    self.image = _image
    
    self.save
  end
  
  def path
    "#{Settings.podcast_folder}/#{self.id}"
  end
  
  def download_episodes
    new_podcasts = check_for_new_podcasts
    new_podcasts.each do |podcast|
      if podcast.valid?
        podcast.send_later(:download)
        podcasts << podcast
      end
    end
    self.save
  end
  
  private
  
  def check_for_new_podcasts
    doc = get_xml_doc
    
    guids = podcasts.map{|p| p.guid}
    
    podcasts_from_doc = doc.search('item').map do |item|
      p = self.podcasts.build
      p.title = item.search('title').inner_text
      p.description = item.search('description').inner_text
      p.guid = item.search('guid').inner_text
      p.published_at = DateTime.parse(item.search('pubDate').inner_text)
      
      enclosure = item.search('enclosure').first
      
      p.url = enclosure['url']
      p.mime = enclosure['type']
      p.duration = item.search('itunes|duration').inner_text
      p
    end
    
    podcasts_from_doc.reject do |podcast|
      guids.include? podcast.guid
    end
    
  end
  
  def get_xml_doc
    Nokogiri::XML(open(url))
  end
  
end
