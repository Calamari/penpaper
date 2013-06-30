class OpenGraph
  include ActionView::Helpers

  def initialize(params)
    @params = params
  end

  def add(key, value)
    @params[key] = value
  end

  def render
    rendered_string = ''
    @params.each_pair do |key, value|
      if value.kind_of? Array
        value.each do |v|
          rendered_string += tag(:meta, property: "og:#{key}", content: v)
        end
      else
        rendered_string += tag(:meta, property: "og:#{key}", content: value)
      end
    end
    # rendered_string += tag(:meta, property: 'og:title', content: @title)
    # rendered_string += tag(:meta, property: 'og:type',  content: @type || 'website')
    # rendered_string += tag(:meta, property: 'og:url',   content: @url)
    # rendered_string += tag(:meta, property: 'og:image', content: @image) if @image
    rendered_string.html_safe
  end
end
