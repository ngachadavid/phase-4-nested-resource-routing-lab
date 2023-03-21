class ItemsController < ApplicationController

  def index
    if params[:user_id]
      begin
        user = User.find(params[:user_id])
        items = user.items
      rescue ActiveRecord::RecordNotFound
        render_not_found_response
        return
      end
    else
      items = Item.all
    end
    render json: items, except: [:created_at, :updated_at],
    include: :user
  end


  def show
    begin
      item = Item.find(params[:id])
      render json: item, except: [:created_at, :updated_at]
    rescue ActiveRecord::RecordNotFound
      render_not_found_response
    end
  end


  def create
    if params[:user_id]
      begin
        user = User.find(params[:user_id])
        user_id = user.id
        item = Item.create(item_params)
      rescue ActiveRecord::RecordNotFound
        render_not_found_response
        return
      end
    else
      item = Item.create(item_params)
    end
    render json: item, except: [:created_at, :updated_at],
    status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

  def render_not_found_response
    render json: {error: "Item not found"}, status: :not_found
  end

end
