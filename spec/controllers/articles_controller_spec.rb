require 'spec_helper'

describe ArticlesController do

  let(:valid_attributes) { Fabricate.attributes_for(:article) }
  let(:valid_session) { {} }

  let(:article) { Fabricate(:published_article) }
  let(:draft) { Fabricate(:article) }

  describe "GET index" do
    it "assigns all articles as @articles" do
      article
      get :index, {}, valid_session
      assigns(:articles).should eq([article])
    end
  end

  describe "GET show" do
    it "assigns the requested article as @article" do
      get :show, {:slug => article.slug}, valid_session
      assigns(:article).should eq(article)
    end

    it "shows 404 if aritlce is draft" do
      get :show, {:slug => draft.slug}, valid_session
      expect(response.status).to be 404
    end
  end

  describe "GET new" do
    let!(:draft1) { Fabricate(:article) }
    let!(:draft2) { Fabricate(:article) }

    it "assigns a new article as @article" do
      get :new, {}, valid_session
      assigns(:article).should be_a_new(Article)
    end

    it "assigns all drafts to @drafts" do
      get :new, {}, valid_session
      expect(assigns(:drafts)).to eql [draft1, draft2]
    end
  end

  describe "GET edit" do
    it "assigns the requested article as @article" do
      article = Article.create! valid_attributes
      get :edit, {:id => article.to_param}, valid_session
      assigns(:article).should eq(article)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Article" do
        expect {
          post :create, {:article => valid_attributes}, valid_session
        }.to change(Article, :count).by(1)
      end

      it "assigns a newly created article as @article" do
        post :create, {:article => valid_attributes}, valid_session
        assigns(:article).should be_a(Article)
        assigns(:article).should be_persisted
      end

      describe "without published flag" do
        before do
          post :create, {:article => valid_attributes}, valid_session
        end

        it "let it be a draft" do
          assigns(:article).should be_draft
        end

        it "redirects to the edit article page" do
          response.should redirect_to(edit_article_path(Article.last))
        end
      end

      describe "with published flag" do
        before do
          post :create, {:article => valid_attributes, :publish => ''}, valid_session
        end

        it "makes it published" do
          assigns(:article).should be_published
        end

        it "redirects to the created article" do
          response.should redirect_to(show_article_path(:slug => Article.last.slug))
        end
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved article as @article" do
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        post :create, {:article => { "title" => "invalid value" }}, valid_session
        assigns(:article).should be_a_new(Article)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        post :create, {:article => { "title" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested article" do
        # Assuming there are no other articles in the database, this
        # specifies that the Article created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Article.any_instance.should_receive(:update_attributes).with({ "title" => "MyString" })
        put :update, {:id => draft.to_param, :article => { "title" => "MyString" }}, valid_session
      end

      it "assigns the requested article as @article" do
        put :update, {:id => draft.to_param, :article => valid_attributes}, valid_session
        assigns(:article).should eq(draft)
      end

      it "but without published flag is still is draft" do
        put :update, {:id => draft.to_param, :article => valid_attributes}, valid_session
        assigns(:article).should be_draft
      end

      describe "with published flag" do
        before do
          put :update, {:id => draft.to_param, :article => valid_attributes, :publish => ''}, valid_session
        end

        it "makes it published" do
          assigns(:article).should be_published
        end

        it "redirects to the article" do
          response.should redirect_to(show_article_path(:slug => article.slug))
        end
      end

      describe "with draft flag" do
        before do
          put :update, {:id => article.to_param, :article => valid_attributes, :draft => ''}, valid_session
        end

        it "makes it draft" do
          assigns(:article).should be_draft
        end

        it "redirects to the edit article path" do
          response.should redirect_to(edit_article_path(article))
        end
      end
    end

    describe "with invalid params" do
      it "assigns the article as @article" do
        article = Article.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        put :update, {:id => article.to_param, :article => { "title" => "invalid value" }}, valid_session
        assigns(:article).should eq(article)
      end

      it "re-renders the 'edit' template" do
        article = Article.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        put :update, {:id => article.to_param, :article => { "title" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested article" do
      article = Article.create! valid_attributes
      expect {
        delete :destroy, {:id => article.to_param}, valid_session
      }.to change(Article, :count).by(-1)
    end

    it "redirects to the articles list" do
      article = Article.create! valid_attributes
      delete :destroy, {:id => article.to_param}, valid_session
      response.should redirect_to(articles_url)
    end
  end

end
