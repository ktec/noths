class Checkout
  def initialize(catalogue,promotional_rules=[])
    @catalogue = catalogue
    @promotional_rules = promotional_rules
  end
  def scan (item)
    items << item
  end
  def total
    ## apply discounts
    discount = 0
    @promotional_rules.each do |rule|
      discount += rule.get_discount(items)
    end
    total = items.inject(0){|sum,item| sum + item.price} - discount
    # round to pennies
    (total*100).round / 100.0
  end
  private
    def items
      @items ||= []
    end
end