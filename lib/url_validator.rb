require 'net/http'
 
# Original credits: http://www.igvita.com/2006/09/07/validating-url-in-ruby-on-rails/l
 
class UrlValidator < ActiveModel::EachValidator
  
  ErrorMessage = 'is not valid or not responding'
  
  def validate_each(record, attribute, value)
    begin # check header response
      res = Net::HTTP.get_response(URI.parse(value))

      case res
        when Net::HTTPRedirection
          until !res.is_a? Net::HTTPRedirection
            return true unless res.get_fields('location')
            res = Net::HTTP.get_response(URI.parse(res.get_fields('location').first))
          end
          res.is_a?(Net::HTTPSuccess) ? true : record.errors[attribute] << (options[:message] || ErrorMessage) && false
    
        when Net::HTTPSuccess then true
        else record.errors[attribute] << (options[:message] || ErrorMessage) && false
      end
    rescue Exception => e# Recover on DNS failures..
      record.errors[attribute] << (options[:message] || ErrorMessage) && false
    end
  end
  
end
 