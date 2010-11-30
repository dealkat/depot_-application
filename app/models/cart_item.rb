# To change this template, choose Tools | Templates
# and open the template in the editor.
class CartItem
  attr_reader :product, :quantity
  def initialize(product)
    @product = product
    @quantity = 1
  end
  def increment_quantity
    @quantity += 1
  end
  def decrement_quantity
    @quantity -= 1
  end
  def title
    @product.title
  end
  def price
    @product.price * @quantity
  end
  def total_price
  @items.sum { |item| item.price }
  end

end
