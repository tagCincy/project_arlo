class Api::Service::V1::SolutionsController < ApplicationController
  respond_to :json

  before_action :set_solution, only: [:show, :update, :destroy]
  before_action :get_issue, only: [:index, :create]

  def index
    @solutions = @issue.solutions

    if @solutions.empty?
      head :bad_request
    end
  end

  def show

  end

  def create
    @solution = @issue.solutions.build solution_params

    if @solution.save
      render action: :show, status: :created
    else
      render json: @solution.errors, status: :unprocessable_entity
    end
  end

  def update
    if @solution.update(solution_params)
      render action: :show, status: :ok
    else
      render json: @solution.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @solution.destroy
      head :ok
    else
      render json: @solution.errors, status: :unprocessable_entity
    end
  end

  private

  def set_solution
    @solution = Solution.find(params[:id])
  end

  def get_issue
    @issue = Issue.find(params[:issue_id])
  end

  def solution_params
    params.require(:solution).permit(:solution, :account_id, :accepted)
  end
end
