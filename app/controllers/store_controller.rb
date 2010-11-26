class StoreController < ApplicationController
  def index
    @products = Product.find_products_for_sale
   end
#   def add_to_cart
#     @cart = find_cart
#     product = Product.find(params[:id])
#     @cart.add_product(product)
#   end

    def add_to_cart
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}" )
      redirect_to_index("Invalid product" )
    else
      @cart = find_cart
      @cart.add_product(product)
    end
  end
  def empty_cart
    session[:cart] = nil
    redirect_to_index("Your cart is currently empty" )
  end
private
 def find_cart
    session[:cart] ||= Cart.new
  end
  def redirect_to_index(msg)
    flash[:notice] = msg
    redirect_to :action => :index
  end

end
