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
end
