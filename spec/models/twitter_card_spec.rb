require 'spec_helper'

describe TwitterCard do
  describe :initialize do
    it 'renders what is given' do
      twitter = TwitterCard.new :title => 'bla', :type => 'summary'
      twitter.render_tags.should include('twitter:title')
      twitter.render_tags.should include('bla')
      twitter.render_tags.should include('twitter:type')
      twitter.render_tags.should include('summary')
    end
  end

  describe :add do
    it 'renders what was added' do
      twitter = TwitterCard.new
      twitter.add 'title', 'bla'
      twitter.add 'type', 'summary'
      twitter.render_tags.should include('twitter:title')
      twitter.render_tags.should include('bla')
      twitter.render_tags.should include('twitter:type')
      twitter.render_tags.should include('summary')
    end
  end
end
