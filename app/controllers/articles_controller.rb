class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.published.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.published.find_by_slug!(params[:slug])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

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
    publish_or_not

    respond_to do |format|
      if @article.save
        if @article.published?
          flash[:success] = 'Article was successfully published.'
          format.html { redirect_to show_article_path(:slug => @article.slug) }
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
          format.html { redirect_to show_article_path(:slug => @article.slug) }
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
