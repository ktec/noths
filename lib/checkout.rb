class Checkout
  def initialize(catalogue,promotional_rules=[])
    @catalogue = catalogue
    @promotional_rules = promotional_rules
  end
  def scan (item)
    items << item
  end
  def total
    total = items.inject(0){|sum,item| sum + item.price}
    ## apply discount rules
    @promotional_rules.each do |rule|
      total += rule.get_discount(items)
    end
    total
  end
  private
    def items
      @items ||= []
    end
end