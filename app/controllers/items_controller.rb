class ItemsController < ApplicationController

  # before_action :find_user, only: [:index, :show, :create]

  def index
    if params[:user_id] && find_user
      items = find_user.items
    elsif params[:user_id]
      return render_not_found
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: item, include: :user
    else
      render_not_found
    end
  end

  def create
    new_item = find_user.items.create(item_params)
    render json: new_item, include: :user, status: :created
  end

  private

    def find_user
      user = User.find_by(id: params[:user_id])
    end 

    def item_params
      params.permit(:name, :description, :price, :user_id)
    end

    def render_not_found
      render json: {error: "not found"}, status: :not_found
    end
end
