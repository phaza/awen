class PodcastSubscription < ActiveRecord::Base
  
  validates_uri_existence_of :url
  
  
  def check_for_new_items
    
  end
  
  def parse
    doc = Nokogiri::XML(open(url))
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
    
  end
  
end
