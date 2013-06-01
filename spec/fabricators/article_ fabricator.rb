Fabricator(:article) do
  title { 'My Title' }
  text { 'lorem ipsum' }
  user_id { Fabricate(:user).id }
end

Fabricator(:published_article, from: :article) do
  published_at { Time.now }
end
