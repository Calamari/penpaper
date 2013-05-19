Fabricator(:article) do
  title { 'My Title' }
  text { 'lorem ipsum' }
end

Fabricator(:published_article, from: :article) do
  title { 'My Title' }
  text { 'lorem ipsum' }
  published_at { Time.now }
end
