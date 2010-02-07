require 'test_helper'

class PodcastSubscriptionTest < Test::Unit::TestCase
  should "not save PodcastSubscription without valid url" do
    @ps = Factory.build(:podcast_subscription)
    @ps.url = ''
    assert !@ps.save
  end
  
  should "save PodcastSubscription with valid url" do
    @ps = Factory.build(:podcast_subscription)
    assert @ps.save
  end
    
  context "a PodcastSubscription instance" do
    setup do
      @ps = Factory.create(:podcast_subscription)
    end
    
    should "return description" do
      
      assert_equal @ps.description, 'Seks romvesener lander på jorda for å finne ut alt hva barn holder på med. Last ned sesong 2 gratis.'
    end
      
    should "return title" do
      assert_equal @ps.title,  'NRK – Kometkameratene'
    end
    should "return image url" do
      assert_equal @ps.image, 'http://www.nrk.no/img/623988.gif'
    end
  end
end
