class ArticlesController < ApplicationController

  before_filter :redirect_if_logged_out, :except => [:index, :show, :list]

  # GET /articles
  # GET /articles.json
  def index
    limit = 3
    @articles = Article.published.order('published_at DESC').limit(limit+1).all

    if @articles.size == limit+1
      @articles.pop
      @show_more_link = true
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /list
  def list
    @articles = Article.published.order('published_at DESC').all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.published.find(params[:id])

    @open_graph = @article.open_graph
    @twitter_card = @article.twitter_card

    if request.path != article_path(@article)
      redirect_to @article, status: :moved_permanently
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new
    @drafts = Article.draft.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])
    @article.user_id = current_user.id
    publish_or_not

    respond_to do |format|
      if @article.save
        if @article.published?
          flash[:success] = 'Article was successfully published.'
          format.html { redirect_to article_path(@article) }
        else
          flash[:success] = 'Article was successfully saved.'
          format.html { redirect_to edit_article_path(@article) }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])
    was_published = @article.published?
    publish_or_not

    respond_to do |format|
      if @article.update_attributes(params[:article])
        if @article.published?
          if was_published
            flash[:success] = 'Article was successfully updated.'
          else
            flash[:success] = 'Article was successfully published.'
          end
          format.html { redirect_to article_path(@article) }
        else
          if was_published
            flash[:success] = 'Article was successfully saved and unpublished.'
          else
            flash[:success] = 'Article was successfully saved.'
          end
          format.html { redirect_to edit_article_path(@article) }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  private

  def publish_or_not
    @article.publish unless params[:publish].nil?
    @article.unpublish unless params[:draft].nil?
  end
end
