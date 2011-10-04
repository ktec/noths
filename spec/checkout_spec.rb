require File.dirname(__FILE__) + '/spec_helper'
require 'ruby-debug'

module CheckoutSpecHelper
  def catalogue
    [
      double(001, :name => "Lavender heart", :price => 9.25),
      double(002, :name => "Personalised cufflinks", :price => 45.00 ),
      double(003, :name => "Kids T-shirt", :price => 19.95 )
    ]
  end
end

describe Checkout, '#total' do
  include CheckoutSpecHelper
  context "without discount rules" do
    let(:checkout) { Checkout.new(catalogue) }
    it "returns 0 for no items" do
      checkout.total.should == 0
    end
    it "returns correct price for one item" do
      item1,item2,item3 = catalogue
      checkout.scan(item1)
      checkout.total.should == item1.price
    end
    it "returns correct price for two of the same item" do
      item1,item2,item3 = catalogue
      checkout.scan(item1)
      checkout.scan(item1)
      checkout.total.should == item1.price + item1.price
    end
    it "returns correct price for two different items" do
      item1,item2,item3 = catalogue
      checkout.scan(item1)
      checkout.scan(item2)
      checkout.total.should == item1.price + item2.price
    end
  end
  context "with discounted prices" do
    let(:promotional_rules) { [
        #PromotionalRule.new()
        ] }
    let(:checkout) { Checkout.new(catalogue,promotional_rules) }
    it "returns correct price for one item" do
      item1,item2,item3 = catalogue
      checkout.scan(item1)
      checkout.total.should == item1.price
    end
    it "returns correct price for two items" do
      item1,item2,item3 = catalogue
      checkout.scan(item1)
      checkout.scan(item1)
      checkout.total.should == item1.price + item1.price
    end
    
  end
end
