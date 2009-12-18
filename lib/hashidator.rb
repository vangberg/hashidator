class Hashidator
  def self.validate(schema, input)
    hd = new(schema)
    hd.validate(input)
  end

  attr_accessor :schema, :errors

  def initialize(schema)
    @schema = schema
  end

  def validate(input)
    results = []

    schema.each { |key, validator|
      value = input[key]
      
      results << case validator
      when Range;
        validator.include? value
      when Array;
        if validator[0].is_a? Symbol
          value.respond_to? validator[0]
        else
          value.all? {|x| x.is_a? validator[0]}
        end
      when Symbol;
        value.respond_to? validator
      when Hash;
        Hashidator.validate(validator, value)
      when Class, Module;
        value.is_a? validator
      end
    }

    results.all?
  end
end

module Boolean
end

class TrueClass
  include Boolean
end

class FalseClass
  include Boolean
end
