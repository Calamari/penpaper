require 'spec_helper'

describe "articles/new" do
  before(:each) do
    assign(:article, Fabricate(:article))
  end

  it "renders new article form" do
    render

    expect(page).to have_css("input#article_title[name='article[title]']")
    expect(page).to have_css("textarea#article_text[name='article[text]']")
  end
end
