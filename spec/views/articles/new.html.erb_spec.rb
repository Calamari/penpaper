require 'spec_helper'

describe "articles/new" do
  before(:each) do
    assign(:article, stub_model(Article,
      :title => "MyString",
      :text => "MyText",
      :html => "MyText",
      :slug => "MyString"
    ).as_new_record)
  end

  it "renders new article form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", articles_path, "post" do
      assert_select "input#article_title[name=?]", "article[title]"
      assert_select "textarea#article_text[name=?]", "article[text]"
      assert_select "textarea#article_html[name=?]", "article[html]"
      assert_select "input#article_slug[name=?]", "article[slug]"
    end
  end
end
