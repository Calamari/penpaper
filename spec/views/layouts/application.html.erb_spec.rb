require 'spec_helper'

describe "layouts/application" do
  describe "if logged in" do
    before do
      view.stub(:current_user).and_return(Fabricate(:user))
      render
    end

    it { expect(page).to have_link("Logout") }
    it { expect(page).to have_link("Write a post") }
  end

  describe "if logged out" do
    before do
      view.stub(:current_user).and_return(nil)
      render
    end

    it { expect(page).to have_link("Login") }
    it { expect(page).to_not have_link("Write a post") }
  end
end
