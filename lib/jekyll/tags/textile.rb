require 'include'

module Jekyll

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

Liquid::Template.register_tag('textile', Jekyll::TextileIncludeTag)
