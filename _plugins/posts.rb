require 'nokogiri'

module Jekyll
  module PostFilters
    def short_title post
      post['short_title'] || post['title']
    end
    
    def summarize post
      doc = Nokogiri::HTML::DocumentFragment.parse(post['content'])
      (doc/'p').first.to_html
    end
  end
  
  ::Liquid::Template.register_filter(PostFilters)
end
