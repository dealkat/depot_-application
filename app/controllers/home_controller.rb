require 'hpricot'
require 'open-uri'
class HomeController < ApplicationController
  def index
    @twitter_results = TwitterResult.find(:all)
  end

  def keywords
    if request.post?
      keyword = params[:keyword]
      url = "http://search.twitter.com/search.atom?q=#{keyword}"
      @data = open(url).read
      @xml_data = Hpricot::XML(@data)
      (@xml_data/:entry).each do |entry|
        @twitter_result = TwitterResult.new
        @img_url = ""
        #if entry.to_s.match("(.*?)<link(.*?)href=\"(.*?)\" rel=\"image\"(.*?)")
        if entry.to_s =~/(.*?)<link(.*?)href=\"(.*?)\" rel=\"image\"(.*?)/
          @img_url = $3.to_s
        end
        #render :text => @img_url.inspect and return false
        @twitter_result.tweet_id = entry.at("id").innerHTML.split(":")[2].to_i if entry.at("id")
        @twitter_result.tweet = entry.at("title").innerHTML if entry.at("title")
        @twitter_result.tweet_date = entry.at("updated").innerHTML.to_datetime if entry.at("updated")
        @twitter_result.screen_name = entry.at("uri").innerHTML.split("/")[3] if entry.at("uri")
        @twitter_result.img_url = @img_url unless @img_url.strip.blank?
        @twitter_result.source = CGI.unescapeHTML(entry.at("twitter:source").innerHTML) if entry.at("twitter:source")
        @twitter_result.keyword = keyword
        #render :text => @twitter_result.attributes.inspect and return false
        @twitter_result.save
      end
    end
  end

end
