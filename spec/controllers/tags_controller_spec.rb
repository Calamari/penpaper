require 'spec_helper'

describe TagsController do
  let!(:tag) { Fabricate(:tag) }
  describe "if logged in" do
    before { login_user Fabricate(:user) }
    let!(:article) { Fabricate(:article) }

    context "#create" do
      it "creates a new tag with given article" do
        expect {
          post :create, { :tag => { name: 'test1' }, :article_id => article.id }
        }.to change{ Tag.count }.by(+1)
        expect(Tag.last.articles).to include(article)
        expect(response).to be_success
        expect(response.body).to include('success')
      end

      it "creates the tag association to post only once" do
        expect {
          post :create, { :tag => { name: 'test1' }, :article_id => article.id }
          post :create, { :tag => { name: 'test1' }, :article_id => article.id }
        }.to change{ Tag.count }.by(+1)
        expect(Tag.last.articles.length).to be 1
      end

      it "create associates an existing tag with given article" do
        existing_tag = Fabricate(:tag)
        expect {
          post :create, { :tag => { name: existing_tag.name }, :article_id => article.id }
        }.to_not change{ Tag.count }
        expect(existing_tag.reload.articles).to include(article)
        expect(response).to be_success
        expect(response.body).to include('success')
      end

      it "returns failure when name is empty" do
        expect {
          post :create, { :tag => { name: '' }, :article_id => article.id }
        }.to_not change{ Tag.count }
        expect(response).to be_bad_request
        json = JSON.parse response.body
        expect(json["errors"]["name"]).to include("can't be blank")
      end

      it "returns failure when article_id is missing" do
        expect {
          post :create, { :tag => { name: 'new tag' } }
        }.to_not change{ Tag.count }
        expect(response).to be_bad_request
        json = JSON.parse response.body
        expect(json["errors"]["article_id"]).to include("can't be blank")
      end

      it "returns failure when article_id is not an article" do
        expect {
          post :create, { :tag => { name: 'new tag' }, :article_id => article.id+1 }
        }.to_not change{ Tag.count }
        expect(response).to be_bad_request
        json = JSON.parse response.body
        expect(json["errors"]["article_id"]).to include("can't be blank")
      end
    end

    context "#show" do
      let(:matching_article) { Fabricate(:article) }
      before do
        tag.articles << matching_article
        tag.save
      end

      it "assigns some vars" do
        post :show, { id: tag.id }
        response.should be_success
        expect(assigns[:tag]).to eql(tag)
        expect(assigns[:articles]).to include(matching_article)
        expect(assigns[:articles]).not_to include(article)
      end
    end
  end

  describe "if logged out" do
    it ":create redirects to root path" do
      post :create, {}
      response.should redirect_to(root_path)
    end

    it ":show is reachable" do
      post :show, { id: tag.id }
      response.should be_success
    end
  end

end
