module RSpec::ViewHelper
  def page
    @page ||= Capybara::Node::Simple.new(rendered)
  end
end
