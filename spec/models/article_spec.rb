require 'spec_helper'

describe Article do
  describe "empty Article" do
    subject { Article.new }

    it { should have(1).error_on(:title) }
    it { should have(0).error_on(:slug) }
    it { should have(1).error_on(:text) }
    it { should have(0).error_on(:html) }
    it { should have(1).error_on(:user_id) }

    it { subject.published?.should_not be true }
    it { subject.draft?.should be true }
  end

  describe "#publish" do
    let(:article) { Fabricate(:article) }
    let(:published_article) { Fabricate(:published_article, published_at: 3.days.ago) }

    it "sets published_at attribute" do
      article.publish
      expect(article.published_at).not_to be nil
    end

    it "does not change published_at attribute if already set" do
      published_article.publish
      expect(published_article.published_at.to_i).to eql 3.days.ago.to_i
    end
  end

  describe "#unpublish" do
    let(:article) { Fabricate(:published_article) }

    it "unsets published_at attribute" do
      article.unpublish
      expect(article.published_at).to be nil
    end
  end

  describe "draft scope" do
    describe "when having no drafts" do
      let!(:article1) { Fabricate(:published_article) }
      let!(:article2) { Fabricate(:published_article) }

      subject { Article.draft }

      it { should be_empty }
    end

    describe "when having draft articles" do
      let!(:article1) { Fabricate(:article) }
      let!(:article2) { Fabricate(:published_article) }

      subject { Article.draft }

      it { subject.length.should be 1 }
      it { subject.should include(article1) }
    end
  end

  describe "published scope" do
    describe "when having no published articles" do
      let!(:article1) { Fabricate(:article) }
      let!(:article2) { Fabricate(:article) }

      subject { Article.published }

      it { should be_empty }
    end

    describe "when having published articles" do
      let!(:article1) { Fabricate(:article) }
      let!(:article2) { Fabricate(:published_article) }

      subject { Article.published.all }

      it { subject.length.should be 1 }
      it { subject.should include(article2) }
    end
  end

  describe "#author" do
    subject { Fabricate(:article) }
    it { subject.author.should eql User.find(subject.user_id) }
  end

  describe "html attribute" do
    let(:text) { "# Hello\n\n* you fool" }
    let(:result) { "<h1 id=\"hello\">Hello</h1>\n\n<ul>\n  <li>you fool</li>\n</ul>\n" }
    let!(:article) { Article.new Fabricate.attributes_for(:article, :text => text) }
    it "is created on save" do
      expect(article.html).to be nil
      article.save
      expect(article.html).to eql result
    end
  end

  describe "slug attribute" do
    let(:title) { "I am a cool title" }
    let(:result) { "i-am-a-cool-title" }
    let!(:article) { Article.new Fabricate.attributes_for(:article, :title => title) }

    it "is created on save" do
      expect(article.slug).to be nil
      article.save
      expect(article.slug).to eql result
    end
  end

  describe "#teaser" do
    let(:short) { "Here I go" }
    let(:text) { "and more stuff" }
    let(:article) { Article.new Fabricate.attributes_for(:article, :text => "#{short}<!--more-->#{text}") }
    let(:article_without_more) { Article.new Fabricate.attributes_for(:article, :text => "#{short}#{text}") }

    it "returns teaser if there is one" do
      expect(article.teaser).to eql short
      expect(article_without_more.teaser).to eql short + text
    end
  end

  describe "teaser_html attribute" do
    let(:short) { "Here I go" }
    let(:text) { "and more stuff" }
    let(:article) { Article.new Fabricate.attributes_for(:article, :text => "#{short}<!--more-->#{text}") }
    let(:article_without_more) { Article.new Fabricate.attributes_for(:article, :text => "#{short} #{text}") }

    it "is created on save" do
      expect(article.teaser_html).to be nil
      article.save
      expect(article.teaser_html).to eql "<p>#{short}</p>\n"

      expect(article_without_more.teaser_html).to be nil
      article_without_more.save
      expect(article_without_more.teaser_html).to eql "<p>#{short} #{text}</p>\n"
    end
  end

  describe "having a tag" do
    let(:article) { Fabricate(:article) }
    let(:tag1) { Fabricate(:tag) }

    it "can be assigned to a article" do
      article.tags << tag1
      expect(article.tags.length).to eql 1
    end
  end

  describe :open_graph do
    let(:article) { Fabricate(:article).tap {|a| a.publish} }
    subject { article.open_graph.render }

    it { should include(article.title) }
    it { should include(article.published_at.iso8601) }
    it { should include('article') }
  end
end
