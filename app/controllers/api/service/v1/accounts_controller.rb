class Api::Service::V1::AccountsController < ApplicationController
  respond_to :json

  before_action :set_account, only: [:show, :update, :add_groups, :remove_groups, :destroy]

  def index
    @accounts = Account.all
  end

  def show
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      sign_in @account.user
      render action: :show, status: :created
    else
      render json: @account.errors, status: :unprocessable_entity
    end

  end

  def update
    if @account.update(account_params)
      render action: :show, status: :ok
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def add_groups
    if @account.member_groups << account_params[:member_groups].map { |m| Group.find(m) }
      head :ok
    end
  end

  def remove_groups
    if @account.member_groups.delete(account_params[:member_groups].map { |m| Group.find(m) })
      head :ok
    end
  end

  def destroy
    if @account.destroy
      head :ok
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:account)
    .permit(:handle, :description, :technician, :admin, user_attributes:
        [:first_name, :last_name, :email, :password, :password_confirmation], member_groups: [])
  end
end
