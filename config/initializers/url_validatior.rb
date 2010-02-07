require 'net/http'
 
# Original credits: http://www.igvita.com/2006/09/07/validating-url-in-ruby-on-rails/l
 
ActiveRecord::Base.class_eval do
  def self.validates_uri_existence_of(*attr_names)
    configuration = { :message => "is not valid or not responding", :on => :save}
    configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)

    validates_each(attr_names, configuration) do |r, a, v|
      begin # check header response
        res = Net::HTTP.get_response(URI.parse(v))

        case res
          when Net::HTTPRedirection
            until !res.is_a? Net::HTTPRedirection
              return true unless res.get_fields('location')
              res = Net::HTTP.get_response(URI.parse(res.get_fields('location').first))
            end
            res.is_a?(Net::HTTPSuccess) ? true : r.errors.add(a, configuration[:message]) && false
      
          when Net::HTTPSuccess then true
          else r.errors.add(a, configuration[:message]) and false
        end
      rescue Exception => e# Recover on DNS failures..
        r.errors.add(a, configuration[:message]) and false
      end
    end
  end
end
 