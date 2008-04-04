require 'avatar/source/gravatar_source'

class SizedGravatarSource < Avatar::Source::GravatarSource
  
  alias_method :parse_options_without_size, :parse_options
  
  def self.sizes
    { :small => 50, :medium => 100, :large => 150, :big => 150 }
  end
  
  def parse_options(profile, options)
    #pass :gravatar_size through, but translate :size or :s to a number if possible
    parsed_options = parse_options_without_size(profile, options)
    [:size, :s].each do |k|
      parsed_options[k] = self.class.sizes[options[k]] if self.class.sizes.has_key?(options[k])
    end
    parsed_options
  end
  
end