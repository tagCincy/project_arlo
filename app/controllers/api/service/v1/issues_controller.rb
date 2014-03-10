class Api::Service::V1::IssuesController < ApplicationController
  respond_to :json

  before_action :set_issue, only: [:show, :update, :add_category, :remove_category, :destroy]

  def index
    @issues = Issue.all
  end

  def show

  end

  def create
    @issue = Issue.new(issue_params)

    if @issue.save
      render action: :show, status: :created
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  def update
    if @issue.update(issue_params)
      render action: :show, status: :ok
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  def add_category
    if @issue.categories << issue_params[:category_ids].map { |c| Category.find(c) }
      head :ok
    end
  end

  def remove_category
    if @issue.categories.delete(issue_params[:category_ids].map { |c| Category.find(c) })
      head :ok
    end
  end

  def destroy
    if @issue.destroy
      head :ok
    else
      render json: @issue.errors, status: :unprocessable_entity
    end
  end

  private
  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:subject, :description, :account_id, category_ids: [])
  end
end
