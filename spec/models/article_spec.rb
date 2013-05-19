require 'spec_helper'

describe Article do
  describe "empty Article" do
    subject { Article.new }

    it { should_not be_valid(:title) }
    it { should_not be_valid(:slug) }
    it { should_not be_valid(:text) }
    it { should_not be_valid(:html) }

    it { subject.published?.should_not be true }
    it { subject.draft?.should be true }
  end


  describe "draft scope" do
    describe "when having no drafts" do
      let!(:article1) { Fabricate(:article, :published_at => Time.now) }
      let!(:article2) { Fabricate(:article, :published_at => Time.now) }

      subject { Article.draft }

      it { should be_empty }
    end

    describe "when having draft articles" do
      let!(:article1) { Fabricate(:article) }
      let!(:article2) { Fabricate(:article, :published_at => Time.now) }

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
      let!(:article2) { Fabricate(:article, :published_at => Time.now) }

      subject { Article.published.all }

      it { subject.length.should be 1 }
      it { subject.should include(article2) }
    end
  end
end
