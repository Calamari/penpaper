require 'spec_helper'

describe Tag do
  describe "empty Tag" do
    subject { Tag.new }

    it { should have(1).error_on(:name) }
  end

  describe "when there is one" do
    let!(:tag1) { Fabricate(:tag) }
    let!(:article) { Fabricate(:article) }

    it "cannot create a tag with same name" do
      tag2 = Tag.new name: tag1.name

      tag2.should have(1).error_on(:name)
    end

    it "can be assigned to a article" do
      tag1.articles << article
      expect(tag1.articles.length).to eql 1
    end
  end
end
