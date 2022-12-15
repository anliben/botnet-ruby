require "async"
require "async/http/internet"
require 'json'
require 'open-uri'
require 'nokogiri'



def GETAsync(link)
  link_ok = ""

  Async do |task|

    task.async do
        uri = URI.open(link)
        doc = Nokogiri::HTML(uri)
        link_ok = doc.css('.copy-content').text
    end
  end
  return link_ok
end
