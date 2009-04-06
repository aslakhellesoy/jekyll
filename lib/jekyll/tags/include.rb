module Jekyll

  class IncludeTag < Liquid::Tag
    def initialize(tag_name, file, tokens)
      super
      @file = file.strip
    end
    
    def check_file(file)
      return @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
    end
    
    def render(context)
      if check_file(@file)
        return "Include file '#{@file}' contains invalid characters or sequences"
      end

      Dir.chdir(File.join(context.registers[:site].source, '_includes')) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(@file)
          source = File.read(@file)
          partial = Liquid::Template.parse(source)
          context.stack do
            partial.render(context)
          end
        else
          "Included file '#{@file}' not found in _includes directory"
        end
      end
    end
  end
  
  class TextileIncludeTag < IncludeTag
    def render(context)
      if check_file(@file)
        return "Include file '#{@file}' contains invalid characters or sequences"
      end

      Dir.chdir(File.join(context.registers[:site].source, '_includes')) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(@file)
          source = File.read(@file)
          html = RedCloth.new(source).to_html
          partial = Liquid::Template.parse(html)
          context.stack do
            partial.render(context)
          end
        else
          "Included file '#{@file}' not found in _includes directory"
        end
      end
    end
  end

end

Liquid::Template.register_tag('include', Jekyll::IncludeTag)
Liquid::Template.register_tag('textile_include', Jekyll::TextileIncludeTag)