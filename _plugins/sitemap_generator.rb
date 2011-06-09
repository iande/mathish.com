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
end

Liquid::Template.register_filter(SitemapFilters)
