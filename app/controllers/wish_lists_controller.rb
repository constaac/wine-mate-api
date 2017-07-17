class WishListsController < ApplicationController
  before_action :set_wish_list, only: [:show, :update, :destroy]

  # GET /wish_lists
  def index
    @wish_lists = WishList.all

    render json: @wish_lists
  end

  # GET /wish_lists/1
  def show
    render json: @wish_list
  end

  # POST /wish_lists
  def create
    @wish_list = WishList.new(wish_list_params)

    if @wish_list.save
      render json: @wish_list, status: :created, location: @wish_list
    else
      render json: @wish_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /wish_lists/1
  def update
    if @wish_list.update(wish_list_params)
      render json: @wish_list
    else
      render json: @wish_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /wish_lists/1
  def destroy
    @wish_list.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wish_list
      @wish_list = WishList.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def wish_list_params
      params.require(:wish_list).permit(:name, :winery, :size, :location, :vintage, :grape)
    end
end
