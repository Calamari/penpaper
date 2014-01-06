class TwitterCard < PrefixedMetaTags
  include ActionView::Helpers

  def initialize(params={})
    super('twitter', params)
  end
end
