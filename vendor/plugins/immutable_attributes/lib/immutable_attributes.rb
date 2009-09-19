module ImmutableErrors
  class ImmutableAttributeError < ActiveRecord::ActiveRecordError
  end
end

ActiveRecord.send :include, ImmutableErrors

module ImmutableAttributes
  def attr_immutable(*args)
    args.each do |meth|
      class_eval do
        define_method("#{meth}=") do |value|
          new_record? ? write_attribute(meth, value) : raise(ActiveRecord::ImmutableAttributeError, "#{meth} is immutable!")
        end
      end
    end
  end
end

ActiveRecord::Base.extend ImmutableAttributes