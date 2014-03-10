class Api::Service::V1::CommentsController < ApplicationController
  respond_to :json

  before_action :set_comment, only: [:show, :update, :destroy]
  before_filter :load_commentable, except: [:show, :update, :destroy]
  before_filter :get_commentable, only: [:destroy]

  def index
    @comments = Comment.where('commentable_id = ?', @commentable.id).order(:id)
  end

  def show

  end

  def create
    @comment = Comment.new(comment_params)
    if @commentable.comments << @comment
      render action: :show, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render action: :show, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end

  end

  def destroy
    if @comment.destroy
      head :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment, :account_id)
  end

  def load_commentable
    klass = [Issue, Solution].detect { |c| params["#{c.name.underscore}_id"]}
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def get_commentable
    klass = Object.const_get @comment.commentable_type
    @commentable = klass.find(@comment.commentable_id)
  end
end
