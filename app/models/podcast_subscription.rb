class PodcastSubscription < ActiveRecord::Base
  
  has_many :podcasts, :dependent => :destroy
  
  validates_uri_existence_of :url
  validates_uniqueness_of :url
  
  after_create :delayed_selfupdate
  before_destroy :cleanup
    
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
    
    write_attribute(:description, _description)
    write_attribute(:title, _title)
    write_attribute(:image, _image)
    
    self.save
  end
  
  def path
    "#{Settings.podcast_folder}/#{self.id}"
  end
  
  def download_episodes
    new_podcasts = check_for_new_podcasts
    Podcast.transaction do
      new_podcasts.map do |podcast|
        podcast.send_later(:download) if podcast.save
      end
    end
  end
  
  private
  def cleanup
    FileUtils.rm_f(self.path)
  end
  
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
