require File.dirname(__FILE__) + '/../lib/checkout'
require File.dirname(__FILE__) + '/../lib/promotional_rule'

# Taken from 
# http://wincent.com/knowledge-base/Fixtures_considered_harmful%3F
class Hash
  # for excluding keys
  def except(*exclusions)
    self.reject { |key, value| exclusions.include? key.to_sym }
  end

  # for overriding keys
  def with(overrides = {})
    self.merge overrides
  end
end