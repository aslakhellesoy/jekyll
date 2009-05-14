module Jekyll

  class TestTag < Liquid::Tag
    def initialize(tag_name, string, tokens)
      super
      @string = string
    end
    
    def render(context)
      return "!!#{@string}!!"
    end
  end
end

Liquid::Template.register_tag('test', Jekyll::TestTag)
