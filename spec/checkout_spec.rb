require File.dirname(__FILE__) + '/spec_helper'
require 'ruby-debug'

module CheckoutSpecHelper
  class Product
    def initialize ( id, name, price ) 
      @id = id
      @name = name
      @price = price
    end
    attr_accessor :id, :name, :price
  end
  def catalogue
    @catalogue ||= [
      Product.new("001", "Lavender heart", 9.25 ),
      Product.new("002", "Personalised cufflinks", 45.00 ),
      Product.new("003", "Kids T-shirt", 19.95 )
    ]
  end
  # If you spend over £60, then you get 10% off your purchase 
  def discount1
    PromotionalRule.new("over_60_pounds") do |items|
      total = items.inject(0){|sum,item| 
        sum + item.price
      }
      if total > 60
        discount = (total/100 * 10)
      else
        discount = 0
      end
    end
  end
  # If you buy 2 or more lavender hearts (001) then the price drops to £8.50
  def discount2
    PromotionalRule.new("2_or_more_lavender_hearts") do |items|
      # count lavender hearts
      hearts = items.find_all{|item| item.id == "001" }
      if hearts.count >= 2
        # discount the lavender hearts
        hearts.each do |heart| 
          heart.price = 8.50 
        end
      end
      discount = 0
    end
  end
end

describe Checkout, '#total' do
  include CheckoutSpecHelper
  before(:all) do
    @item1,@item2,@item3 = catalogue    
  end
  context "without discount rules" do
    let(:checkout) { Checkout.new(catalogue) }
    it "returns 0 for no items" do
      checkout.total.should == 0
    end
    it "returns correct price for one item" do
      checkout.scan(@item1)
      checkout.total.should == 9.25
    end
    it "returns correct price for two of the same item" do
      checkout.scan(@item1)
      checkout.scan(@item1)
      checkout.total.should == 18.5
    end
    it "returns correct price for two different items" do
      checkout.scan(@item1)
      checkout.scan(@item2)
      checkout.total.should == 54.25
    end
  end
  context "with discounted prices" do

    let(:promotional_rules) { [ 
      discount2,
      discount1
    ] }

    let(:checkout) { Checkout.new(catalogue,promotional_rules) }

    # Basket: 001,002,003
    # 9.25 = 9.25
    # Total price expected: £9.25

    it "returns correct price for one item" do
      checkout.scan(@item1)
      checkout.total.should == 9.25
    end

    # Basket: 001,002,003
    # 45 + 19.95 = 64.95 - 10% = 58.455
    # Total price expected: £58.46

    it "returns correct price for two items" do
      basket = [@item2,@item3]
      basket.each {|item|
        checkout.scan(item)
      }
      checkout.total.should == 58.46
    end

    # Basket: 001,002,003 
    # 9.25 + 45 + 19.95 = 74.2 - 10% = 66.78
    # Total price expected: £66.78

    it "returns 66.78 with a basket of 001,002,003" do
      basket = [@item1,@item2,@item3]
      basket.each {|item|
        checkout.scan(item)
      }
      checkout.total.should == 66.78
    end

    # Basket: 001,003,001
    # 8.50 + 19.95 + 8.50 = 36.95
    # Total price expected: £36.95

    it "returns 36.95 with a basket of 001,003,001" do
      basket = [@item1,@item3,@item1]
      basket.each {|item|
        checkout.scan(item)
      }
      checkout.total.should == 36.95
    end

    # Basket: 001,002,001,003
    # This total is affected by the order the discounts are applied:
    # 9.25+45+9.25+19.95 = 83.45 - 8.345 - (0.75 * 2) = 73.61
    # 8.5+45+8.5+19.95 = 81.95 - 8.195 = 73.76
    # Total price expected: £73.76

    it "returns 73.76 with a basket of 001,002,001,003" do
      item1,item2,item3 = catalogue
      basket = [@item1,@item2,@item1,@item3]
      basket.each {|item|
        checkout.scan(item)
      }
      checkout.total.should == 73.76
    end

  end
end
