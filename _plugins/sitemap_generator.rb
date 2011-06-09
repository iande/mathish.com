module SitemapFilters
  def date_to_sitemap date
    (date || Time.now).strftime("%Y-%m-%d")
  end

  def sitemap_changefreq phsh
    date = (phsh['date'] || Time.now).to_time
    delta = ((Time.now - date) / 86400).to_i
    case delta
    when 0..2
      'daily'
    when 3..14
      'weekly'
    else
      'monthly'
    end
  end
  
  def sitemap_priority phsh
    phsh['sitemap_priority'] || '1.0'
  end
end

module Jekyll  
  class Site
    def site_payload_with_sitemap
      sitemaps = pages.select do |p|
        p.url =~ /sitemap[a-zA-Z0-9\-_]*.xml/
      end
      without_sitemap_index = sitemaps.reject { |p| p.url == '/sitemap.xml' }
      site_payload_without_sitemap.tap do |payload|
        payload['site']['sitemap_pages'] = pages - sitemaps
        payload['site']['sitemaps'] = without_sitemap_index
      end
    end
    
    alias :site_payload_without_sitemap :site_payload
    alias :site_payload :site_payload_with_sitemap
  end
end

Liquid::Template.register_filter(SitemapFilters)
