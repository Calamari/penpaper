require 'spec_helper'

describe Article do
  describe "empty Article" do
    subject { Article.new }

    it { should have(1).error_on(:title) }
    it { should have(0).error_on(:slug) }
    it { should have(1).error_on(:text) }
    it { should have(0).error_on(:html) }

    it { subject.published?.should_not be true }
    it { subject.draft?.should be true }
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

  describe "html attribute" do
    let(:text) { "# Hello\n\n* you fool" }
    let(:result) { "<h1 id=\"hello\">Hello</h1>\n\n<ul>\n  <li>you fool</li>\n</ul>\n" }
    let!(:article) { Fabricate.build(:article, :text => text) }
    it "is created on save" do
      expect(article.html).to be nil
      article.save
      expect(article.html).to eql result
    end
  end

  describe "slug attribute" do
    let(:title) { "I am a cool title" }
    let(:result) { "i-am-a-cool-title" }
    let!(:article) { Fabricate.build(:article, :title => title) }

    it "is created on save" do
      expect(article.slug).to be nil
      article.save
      expect(article.slug).to eql result
    end
  end
end
