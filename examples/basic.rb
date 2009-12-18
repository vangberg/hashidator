require 'hashidator'

schema = {
  :id     => Integer,         # Is integer?
  :name   => String,
  :age    => (13..99),        # Within range?
  :admin  => Boolean,
  :mails  => [String],        # Array consisting of strings?
  :other  => {
    :country_code => :to_i,   # Ducktyping!
    :country      => String
  }
}

valid_input = {
  :id     => 123,
  :name   => "Harry",
  :age    => 21,
  :admin  => true,
  :mails  => ["foo@example.com", "bar@example.com"],
  :other  => {
    :country      => "Denmark",
    :country_code => 12
  }
}

invalid_input = {
  :id     => "whatevz",
  :name   => 42,
  :age    => 12,
  :admin  => :maybe,
  :mails  => ["foo@example.com", 1234],
  :other => {
    :country      => [1,2,3],
    :country_code => (1..2)
  }
}

h = Hashidator.new(schema)
h.validate(valid_input)     #=> true
h.validate(invalid_input)   #=> false
