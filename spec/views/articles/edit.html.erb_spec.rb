require 'spec_helper'

describe "articles/edit" do
  before(:each) do
    @article = assign(:article, stub_model(Article,
      :title => "MyString",
      :text => "MyText",
      :html => "MyText",
      :slug => "MyString"
    ))
  end

  it "renders the edit article form" do
    render

    expect(page).to have_css("input#article_title[name='article[title]']")
    expect(page).to have_css("textarea#article_text[name='article[text]']")
  end
end
