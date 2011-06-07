module Jekyll
  class Post; def base_file; File.join(@base, @name); end; end
  class Page; def base_file; File.join(@base, @name); end; end
  
  class SitemapGenerator < Generator
    priority :low
    
    def generate site
      if site.layouts.key? 'sitemap'
        puts "Building sitemap.xml"
        nodes = site.pages.map { |page| SitemapNode.from_page page }
        nodes += site.posts.map { |post| SitemapNode.from_post post }
        nodes += site.taggings.map { |tag| SitemapNode.from_tagging tag }
        write_sitemap site, nodes
      end
    end
    
    def write_sitemap site, nodes
      index = SitemapPage.new(site, site.source, nodes)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.static_files << index
    end
  end
  
  class SitemapPage < Page
    def initialize site, base, nodes
      @site = site
      @base = base
      @dir = '/'
      @name = 'sitemap.xml'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'sitemap.xml')
      self.data['nodes'] = nodes
    end
  end
  
  class SitemapNode
    URI_BASE = "http://mathish.com"
    
    attr_accessor :url, :file
    
    def initialize file, rel_uri
      @file = file
      if rel_uri =~ /(.*\/)index.html$/
        rel_uri = $1
      end
      @url = URI.parse("#{URI_BASE}#{rel_uri}").to_s
    end
    def mtime
      File.mtime(@file)
    end
    def last_modified; mtime.strftime('%Y-%m-%d'); end
    
    def to_liquid
      { 'url' => @url, 'last_modified' => last_modified }
    end
    
    def self.from_page page
      if page.url == '/index.html'
        SiteIndexNode.new page
      else
        PageNode.new page
      end
    end
    
    def self.from_post post
      PostNode.new post
    end
    
    def self.from_tagging tagging
      TaggingIndexNode.new tagging
    end
  end
  
  class PageNode < SitemapNode
    def initialize page
      super page.base_file, page.url
    end
  end
  
  class PostNode < SitemapNode
    def initialize post
      super post.base_file, post.url
    end
  end
  
  class SiteIndexNode < PageNode
    def initialize page
      super
    end
    def mtime; Date.today; end
  end
  
  class TaggingIndexNode < SitemapNode
    def initialize tagging
      super tagging.filename, tagging.url
      @max_date = tagging.posts.map { |p| p.date }.max
    end
    def mtime; @max_date; end
  end
end
