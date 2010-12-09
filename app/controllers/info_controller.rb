class InfoController < ApplicationController
  layout "store"
  def who_bought
    @product = Product.find(params[:id])
#     render :text => @product and return false
    @orders = @product.orders
#    render :text => @order and return false
    respond_to do |accepts|
      accepts.html
      accepts.xml {render :xml => @product.to_xml(:include => :orders)}
    end
  end
  
  def index
    if params[:sort]
#      render :text => params[:table] and return false
@lineitems = LineItem.find(:all,:joins => "inner join #{params[:table]} on #{params[:table]}.id=line_items.#{params[:table].singularize}_id", :order=>"#{params[:table]}.#{params[:column]} #{params[:sort]}" )
#        render :text => @lineitmes.inspect and return false
#         @lineitems = LineItem.find(:all, :include => "#{params[:table]}",:order=>"#{params[:table]}.#{params[:column]} #{params[:sort]}" )
        @orders = Order.find(:all, :order => :name)
    else
#      @orders = Order.all
     @lineitems = LineItem.find(:all)

    end
    @orders = Order.find(:all, :order => :name)
#    @product = Product.find(:all)
#        render :text => @product and return false

#   @orders = @product.orders
  end

 def sort
   @lineitmes = Order.find(:all,:order=>"#{params[:column]} #{params[:sort]}" )
#  render :text => params.inspect and return false
  redirect_to :back
 end
#  result = 'class="sortup"' if params[:sort] == param
#  result = 'class="sortdown"' if params[:sort] == param + "_reverse"
#  return result



end
