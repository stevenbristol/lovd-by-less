require 'avatar/source/gravatar_source'

class SizedGravatarSource < Avatar::Source::GravatarSource
  
  alias_method :parse_options_without_size, :parse_options
  
  def self.sizes
    { :small => 50, :medium => 100, :large => 150, :big => 150 }
  end
  
  def parse_options(profile, options)
    result = parse_options_without_size(profile, options)
    result[:size] = self.class.sizes[options[:size]] if self.class.sizes.has_key?(options[:size])
    result
  end
  
end