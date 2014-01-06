class PrefixedMetaTags
  def initialize(prefix, params={})
    @prefix = prefix
    @params = params
  end

  def add(key, value)
    @params[key] = value
  end

  def render_tags
    rendered_string = ''
    @params.each_pair do |key, value|
      if value.kind_of? Array
        value.each do |v|
          rendered_string += tag(:meta, property: "#{@prefix}:#{key}", content: v)
        end
      else
        rendered_string += tag(:meta, property: "#{@prefix}:#{key}", content: value)
      end
    end
    rendered_string.html_safe
  end
end
