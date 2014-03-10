class Api::Service::V1::GroupsController < ApplicationController
  respond_to :json

  before_action :set_group, only: [:show, :update, :add_members, :remove_members, :destroy]

  def index
    @groups = Group.all
  end

  def show
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      render action: :show, status: :created
    else
      render json: @group.errors, status: :unprocessable_entity
    end

  end

  def update
    if @group.update(group_params)
      render action: :show, status: :ok
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  def add_members
    if @group.members << group_params[:members].map { |m| Account.find(m)}
      head :ok
    end
  end

  def remove_members
    if @group.members.delete(group_params[:members].map { |m| Account.find(m)})
      head :ok
    end
  end

  def destroy
    if @group.destroy
      head :ok
    else
      render json: @group.errors, status: :unprocessable_entity
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group)
    .permit(:name, :code, :description, :admin_id, members: [], technicians: [])
  end
end
