class Api::Service::V1::CategoriesController < ApplicationController
  respond_to :json

  before_filter :set_category, only: [:show, :update, :destroy]

  def index
    @categories = Category.all
  end

  def show
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render action: :show, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render action: :show, status: :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      head :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
