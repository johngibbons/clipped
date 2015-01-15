class EntourageItemsController < ApplicationController
  before_action :set_entourage_item, only: [:show, :edit, :update, :destroy]
  impressionist actions: [:show]

  # GET /entourage_items
  # GET /entourage_items.json
  def index
    @entourage_items = EntourageItem.all
  end

  # GET /entourage_items/1
  # GET /entourage_items/1.json
  def show

  end

  # GET /entourage_items/new
  def new
    @entourage_item = EntourageItem.new
  end

  # GET /entourage_items/1/edit
  def edit
  end

  # POST /entourage_items
  # POST /entourage_items.json
  def create
    @entourage_item = EntourageItem.new(entourage_item_params)

    respond_to do |format|
      if @entourage_item.save
        format.html { redirect_to @entourage_item, notice: 'Entourage item was successfully created.' }
        format.json { render :show, status: :created, location: @entourage_item }
      else
        format.html { render :new }
        format.json { render json: @entourage_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entourage_items/1
  # PATCH/PUT /entourage_items/1.json
  def update
    respond_to do |format|
      if @entourage_item.update(entourage_item_params)
        format.html { redirect_to @entourage_item, notice: 'Entourage item was successfully updated.' }
        format.json { render :show, status: :ok, location: @entourage_item }
      else
        format.html { render :edit }
        format.json { render json: @entourage_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entourage_items/1
  # DELETE /entourage_items/1.json
  def destroy
    @entourage_item.destroy
    respond_to do |format|
      format.html { redirect_to entourage_items_url, notice: 'Entourage item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entourage_item
      @entourage_item = EntourageItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entourage_item_params
      params.require(:entourage_item).permit(:image, :tag_list, :perspective, :views, :downloads)
    end
end
