class OpenGraph < PrefixedMetaTags
  include ActionView::Helpers

  def initialize(params={})
    super('og', params)
  end
end
