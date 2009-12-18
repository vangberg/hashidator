class Hashidator
  def self.validate(schema, input)
    hd = new

    hd.schema = schema
    hd.input  = input

    hd.validate
  end

  attr_accessor :schema, :input

  def validate
    result = true

    schema.each { |key, validator|
      value = input[key]
      
      case validator
      when Range:
        result = false  unless validator.include? input[key]
      when Array:
        result = false  unless value.all? {|x| x.is_a? validator[0]}
      when Symbol:
        result = false  unless value.respond_to? validator
      when Class, Module:
        if !value.is_a? validator
          result = false
        end
      end
    }

    result
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
