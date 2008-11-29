unless Object.method_defined?(:returning)
  Object.class_eval do
    def returning(value)
      yield(value)
      value
    end
  end
end