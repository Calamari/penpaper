require 'spec_helper'

describe "articles/show" do
  before(:each) do
    @article = assign(:article, stub_model(Article,
      :title => "Title",
      :text => "MyText",
      :html => "MyText",
      :slug => "Slug"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/Slug/)
  end
end
