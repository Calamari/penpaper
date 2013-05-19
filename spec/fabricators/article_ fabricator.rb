Fabricator(:article) do
  title { 'My Title' }
  slug { |attrs| attrs[:title].camelize }
  text { 'lorem ipsum' }
  html { '<p>lorem ipsum</p>' }
end
