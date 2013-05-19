require 'spec_helper'

describe "articles/index" do
  before(:each) do
    assign(:articles, [
      Fabricate(:published_article,
        :title => "Title",
        :text => "MyText"
      ),
      Fabricate(:published_article,
        :title => "Title",
        :text => "MyText"
      )
    ])
  end

  it "renders a list of articles" do
    render

    expect(page).to have_content("Title", count: 2)
    expect(page).to have_content("MyText", count: 2)
  end
end
