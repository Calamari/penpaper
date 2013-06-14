require 'spec_helper'

describe ArticlesController do

  let(:valid_attributes) { Fabricate.attributes_for(:article) }
  let(:valid_session) { {} }

  let(:article) { Fabricate(:published_article, published_at: 3.minutes.ago) }
  let(:draft) { Fabricate(:article) }

  describe "GET index" do
    let!(:article2) { Fabricate(:published_article, published_at: 2.minutes.ago) }
    let!(:article3) { Fabricate(:published_article, published_at: 1.minutes.ago) }
    let!(:article4) { Fabricate(:published_article, published_at: 0.minutes.ago) }
    it "assigns three articles as @articles" do
      article
      get :index, {}
      expect(assigns(:articles).length).to eql 3
      assigns(:articles).should eql([article4, article3, article2])
    end
  end

  describe "GET list" do
    it "assigns all articles as @articles" do
      article
      get :list, {}
      assigns(:articles).should eql([article])
    end
  end

  describe "GET show" do
    it "assigns the requested article as @article" do
      get :show, { :id => article }
      assigns(:article).should eql(article)
    end

    it "shows 404 if aritlce is draft" do
      get :show, { :id => draft }
      expect(response.status).to be 404
    end
  end

  describe "GET new" do
    let!(:draft1) { Fabricate(:article) }
    let!(:draft2) { Fabricate(:article) }

    describe "if logged in" do
      before { login_user Fabricate(:user) }
      it "assigns a new article as @article" do
        get :new, {}
        assigns(:article).should be_a_new(Article)
      end

      it "assigns all drafts to @drafts" do
        get :new, {}
        expect(assigns(:drafts)).to eql [draft1, draft2]
      end
    end

    describe "if logged out" do
      it "redirects to root path" do
        get :new, {}
        expect(flash.alert).to eql "Don't do that."
        response.should redirect_to(root_path)
      end
    end
  end

  describe "GET edit" do
    describe "if logged in" do
      before { login_user Fabricate(:user) }
      it "assigns the requested article as @article" do
        article = Article.create! valid_attributes
        get :edit, {:id => article.to_param}
        assigns(:article).should eq(article)
      end
    end

    describe "if logged out" do
      it "redirects to root path" do
        get :edit, {:id => article.to_param}
        expect(flash.alert).to eql "Don't do that."
        response.should redirect_to(root_path)
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      describe "if logged in" do
        let(:current_user) { Fabricate(:user) }
        before { login_user current_user }
        it "creates a new Article" do
          expect {
            post :create, {:article => valid_attributes}
          }.to change(Article, :count).by(1)
        end

        it "assigns a newly created article as @article" do
          post :create, {:article => valid_attributes}
          expect(assigns(:article)).to be_a(Article)
          expect(assigns(:article)).to be_persisted
        end

        it "sets logged in user as author" do
          post :create, {:article => valid_attributes}
          expect(assigns(:article).author).to eql current_user
        end

        describe "without published flag" do
          before do
            post :create, {:article => valid_attributes}
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
            post :create, {:article => valid_attributes, :publish => ''}
          end

          it "makes it published" do
            assigns(:article).should be_published
          end

          it "redirects to the created article" do
            response.should redirect_to(article_path(Article.last))
          end
        end

        describe "with invalid params" do
          it "assigns a newly created but unsaved article as @article" do
            # Trigger the behavior that occurs when invalid params are submitted
            Article.any_instance.stub(:save).and_return(false)
            post :create, {:article => { "title" => "invalid value" }}
            assigns(:article).should be_a_new(Article)
          end

          it "re-renders the 'new' template" do
            # Trigger the behavior that occurs when invalid params are submitted
            Article.any_instance.stub(:save).and_return(false)
            post :create, {:article => { "title" => "invalid value" }}
            response.should render_template("new")
          end
        end

      end

      describe "if logged out" do
        it "redirects to root path" do
          post :create, {:article => valid_attributes}
          expect(flash.alert).to eql "Don't do that."
          response.should redirect_to(root_path)
        end
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      describe "if logged in" do
        before { login_user Fabricate(:user) }
        it "updates the requested article" do
          # Assuming there are no other articles in the database, this
          # specifies that the Article created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Article.any_instance.should_receive(:update_attributes).with({ "title" => "MyString" })
          put :update, {:id => draft.to_param, :article => { "title" => "MyString" }}
        end

        it "assigns the requested article as @article" do
          put :update, {:id => draft.to_param, :article => valid_attributes}
          assigns(:article).should eq(draft)
        end

        it "but without published flag is still is draft" do
          put :update, {:id => draft.to_param, :article => valid_attributes}
          assigns(:article).should be_draft
        end

        describe "with published flag" do
          before do
            put :update, {:id => draft.to_param, :article => { "title" => "New Title" }, :publish => ''}
          end

          it "makes it published" do
            assigns(:article).should be_published
          end
        end

        describe "with draft flag" do
          before do
            put :update, {:id => article.to_param, :article => valid_attributes, :draft => ''}
          end

          it "makes it draft" do
            assigns(:article).should be_draft
          end

          it "redirects to the edit article path" do
            response.should redirect_to(edit_article_path(article))
          end
        end

        describe "with invalid params" do
          it "assigns the article as @article" do
            article = Article.create! valid_attributes
            # Trigger the behavior that occurs when invalid params are submitted
            Article.any_instance.stub(:save).and_return(false)
            put :update, {:id => article.to_param, :article => { "title" => "invalid value" }}
            assigns(:article).should eq(article)
          end

          it "re-renders the 'edit' template" do
            article = Article.create! valid_attributes
            # Trigger the behavior that occurs when invalid params are submitted
            Article.any_instance.stub(:save).and_return(false)
            put :update, {:id => article.to_param, :article => { "title" => "invalid value" }}
            response.should render_template("edit")
          end
        end
      end

      describe "if logged out" do
        it "redirects to root path" do
          post :create, {:article => valid_attributes}
          expect(flash.alert).to eql "Don't do that."
          response.should redirect_to(root_path)
        end
      end
    end
  end

  describe "DELETE destroy" do
    describe "if logged in" do
      before { login_user Fabricate(:user) }
      it "destroys the requested article" do
        article = Article.create! valid_attributes
        expect {
          delete :destroy, {:id => article.to_param}
        }.to change(Article, :count).by(-1)
      end

      it "redirects to the articles index" do
        article = Article.create! valid_attributes
        delete :destroy, {:id => article.to_param}
        response.should redirect_to(articles_url)
      end
    end

    describe "if logged out" do
      it "redirects to root path" do
        post :create, {:article => valid_attributes}
        expect(flash.alert).to eql "Don't do that."
        response.should redirect_to(root_path)
      end
    end
  end

end
