require 'spec_helper'

describe OpenGraph do
  describe :initialize do
    it 'renders what is given' do
      og = OpenGraph.new :title => 'bla', :foo => 'blubb'
      og.render_tags.should include('og:title')
      og.render_tags.should include('bla')
      og.render_tags.should include('og:foo')
      og.render_tags.should include('blubb')
    end
  end

  describe :add do
    it 'renders what was added' do
      og = OpenGraph.new
      og.add 'title', 'bla'
      og.add 'foo', 'blubb'
      og.render_tags.should include('og:title')
      og.render_tags.should include('bla')
      og.render_tags.should include('og:foo')
      og.render_tags.should include('blubb')
    end
  end
end
