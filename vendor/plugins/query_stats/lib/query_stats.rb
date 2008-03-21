# QueryStats

# The QueryStats module, which contains other modules for the plugin.
module QueryStats
  # Issues a warning that the QueryStats module no longer needs to be manually included in the ApplicationController.
  def self.included(*args)
    $stderr.puts "You no longer need to include the QueryStats module in your controller."
  end
end