class TagsController < ApplicationController
  before_filter :redirect_if_logged_out, :except => :show

  def show
    @tag = Tag.find(params[:id])
    @articles = @tag.articles.all
  end

  def create
    article = Article.find(params[:article_id])
    tag = Tag.find_or_create(params[:tag][:name])
    tag.articles << article
    if tag.save
      render :json => { success: true }
    else
      render :json => { errors: tag.errors }, :status => :bad_request
    end
  rescue ActiveRecord::RecordNotFound => e
    render :json => { errors: { article_id: "can't be blank" } }, :status => :bad_request
  end
end
