require 'spec_helper'

describe User do
  context "a new user" do
    subject { User.new }

    it { should have(1).error_on(:name) }
    it { should have(1).error_on(:email) }
    it { should have(1).error_on(:password) }
  end
end
