class Product < ActiveRecord::Base
  has_many :line_items
  validates_presence_of :title, :description, :image_url
  validates_numericality_of :price
  validate :price_must_be_atleast_one_cent
  validates_uniqueness_of :title
  validates_format_of :image_url,
                      :with => %r{\.(gif|jpg|png)$}i,
                      :message => 'must have gif, jpg' +
                                  'or png image'

  protected
  def price_must_be_atleast_one_cent
    errors.add(:price, 'price must be atleast 0.1') if price.nil? || price < 0.1
  end
  def self.find_products_for_sale
       find(:all, :order => "title")
  end
end
