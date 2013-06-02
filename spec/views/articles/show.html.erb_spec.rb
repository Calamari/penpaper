require 'spec_helper'

describe "articles/show" do
  before(:each) do
    @article = assign(:article, Fabricate(:article,
      :title => "Title",
      :text => "MyText",
      :html => "MyText"
    ).tap {|a| a.publish })
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
  end
end
