class PromotionalRule
  def initialize(name, &block)
    @name, @block = name, block
  end
  def get_discount(items)
    @block.call(items)
  end
end