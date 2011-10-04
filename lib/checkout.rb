class Checkout
  def initialize(catalogue,promotional_rules=[])
    @catalogue = catalogue
    @promotional_rules = promotional_rules
  end
  def scan (item)
    items << item
  end
  def total
    t = items.inject(0){|sum,item| sum + item.price}
    ## apply discount rules
    #@promotional_rules.each do |items|
    #  t += rule.apply_discount(items)
    #end
  end
  private
    def items
      @items ||= []
    end
  #http://stackoverflow.com/questions/2625749/calculate-sum-of-objects-for-each-unique-object-property-in-ruby
end