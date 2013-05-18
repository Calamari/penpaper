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

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", article_path(@article), "post" do
      assert_select "input#article_title[name=?]", "article[title]"
      assert_select "textarea#article_text[name=?]", "article[text]"
      assert_select "textarea#article_html[name=?]", "article[html]"
      assert_select "input#article_slug[name=?]", "article[slug]"
    end
  end
end
