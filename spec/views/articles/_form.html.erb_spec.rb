require 'spec_helper'

describe "articles/_form" do
  describe "for an unpublished article" do
    before do
      assign(:article, Fabricate(:article))
    end

    it "shows the right buttons" do
      render

      expect(page).to have_button("Publish")
      expect(page).to have_button("Save as draft")
    end
  end

  describe "for a published article" do
    before do
      assign(:article, Fabricate(:published_article))
    end

    it "shows the right buttons" do
      render

      expect(page).to have_button("Edit")
      expect(page).to have_button("Unpublish")
    end
  end
end
