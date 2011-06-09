module RssFilters
  
  def rss_date date
    date.strftime("%a, %d %b %Y %T %Z")
  end
  
  def scrub_mathjax str
    str.gsub(/<script type="math\/tex.*?">(.*?)<\/script>/m, '\1')
  end
end

Liquid::Template.register_filter(RssFilters)
