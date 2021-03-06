class Order < ActiveRecord::Base
  has_many :line_items
#  belongs_to :products
  PAYMENT_TYPES = [
  # Displayed         stored in db
  [ "Check" ,          "check" ],
  [ "Credit card" ,    "cc" ],
  [ "Purchase order" , "po" ]
]

  ACTIONS =[
    ["delete", "1"],
    ["edit", "2"]
  ]
  def add_line_items_from_cart(cart)
    cart.items.each do |item|
      li = LineItem.from_cart_item(item)
      line_items << li
    end

  end

validates_presence_of :name, :address, :email, :pay_type
validates_inclusion_of :pay_type, :in =>  PAYMENT_TYPES.map {|disp, value| value}

end
