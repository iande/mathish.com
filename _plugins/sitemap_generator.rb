module SitemapFilters
  def date_to_sitemap date
    date.strftime("%Y-%m-%d")
  end
end

module Jekyll
  class Page
    unless method_defined?(:modified_at)
      def modified_at
        file_path = File.join(@base, @name)
        File.exists?(file_path) ? File.mtime(file_path) : Time.now
      end
    end
    
    def to_liquid_with_mtime
      to_liquid_without_mtime.merge 'mtime' => modified_at
    end
    alias :to_liquid_without_mtime :to_liquid
    alias :to_liquid :to_liquid_with_mtime
  end
  
  class Post
    unless method_defined?(:modified_at)
      def modified_at
        file_path = File.join(@base, @name)
        File.exists?(file_path) ? File.mtime(file_path) : Time.now
      end
    end
    
    def to_liquid_with_mtime
      to_liquid_without_mtime.merge 'mtime' => modified_at
    end
    alias :to_liquid_without_mtime :to_liquid
    alias :to_liquid :to_liquid_with_mtime
  end
  
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
