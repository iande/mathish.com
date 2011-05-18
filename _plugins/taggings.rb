module Jekyll
  class Site
    attr_accessor :taggings
    
    def site_payload_with_taggings
      site_payload_without_taggings.tap do |payload|
        payload['site']['taggings'] = self.taggings
      end
    end
    
    alias :site_payload_without_taggings :site_payload
    alias :site_payload :site_payload_with_taggings
  end
  
  class Post
    def to_liquid_with_taggings
      to_liquid_without_taggings.tap do |liq|
        liq['taggings'] = @site.taggings.select { |t| t.included_in? self.tags }
      end
    end
    
    alias :to_liquid_without_taggings :to_liquid
    alias :to_liquid :to_liquid_with_taggings
  end
  
  class Tagging
    attr_accessor :posts, :description, :name, :url, :filename, :bucket
    
    def initialize dir, tag, posts, min, max
      @raw_name = tag
      @posts = posts.sort { |a,b| b <=> a }
      @name = CGI.escapeHTML(@raw_name)
      @file = @raw_name.gsub(/\s/,'-').gsub(/[^\w-]/,'').downcase
      @description = "#{@posts.size} articles have been tagged '#{@name}'"
      @filename = "#{@file}.html"
      @url = "/#{dir}/#{@filename}"
      @bucket = calculate_bucket min, max
    end
    
    def <=> other
      self.name <=> other.name
    end
    
    def to_liquid
      [:name, :posts, :description, :url, :bucket].inject({}) do |liq, prop|
        liq[prop.to_s] = __send__ prop
        liq
      end
    end
    
    def calculate_bucket min, max
      # 5 buckets: fewest, fewer, avg, more, most
      range = max - min
      slot = (100 * (@posts.size - min)) / max
      case slot
      when  0...20
        'fewest'
      when 20...40
        'fewer'
      when 40...60
        'average'
      when 60...80
        'more'
      else
        'most'
      end
    end
    
    def inspect
      "<Tagging: #{@raw_name}, posts: #{@posts.size}>"
    end
    
    def included_in? tags
      tags.any? { |t| @raw_name == t }
    end
  end
  
  class TaggingIndex < Page
    def initialize site, base, dir, tag
      @site = site
      @base = base
      @dir = dir
      @name = tag.filename
      @tag = tag
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag'] = tag
      self.data['title'] = tag.name
    end
    
    def render_with_posts layouts, payload
      @tag.posts.each do |post|
        post.render layouts, payload
      end
      render_without_posts layouts, payload
    end
    
    alias :render_without_posts :render
    alias :render :render_with_posts
  end
  
  class TaggingGenerator < Generator
    safe true
    
    def generate site
      if site.layouts.key? 'tag_index'
        dir = site.config['tag_dir'] || 'tags'
        min, max = site.tags.map { |t,p| p.size }.minmax
        site.taggings = site.tags.map do |tag, posts|
          Tagging.new dir, tag, posts, min, max
        end.sort
        site.taggings.each do |tag|
          write_tag_index(site, dir, tag)
        end
      end
    end
    
    def write_tag_index site, dir, tag
      index = TaggingIndex.new(site, site.source, dir, tag)
      index.render(site.layouts, site.site_payload)
      index.write(site.dest)
      site.static_files << index
    end
  end
end
