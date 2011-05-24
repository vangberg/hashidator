require 'hashidator'

schema = {
  :id     => Integer,         # Is integer?
  :name   => String,
  :age    => (13..99),        # Within range?
  :admin  => Boolean,
  :mails  => [String],        # Array consisting of strings?
  :other  => {
    :country_code => :to_i,   # Ducktyping!
    :country      => String,
    :random       => /foo/    # Regular expressions
  },
  :result => "ok",
  :bool   => true,
  :validate_array       => [{:name => String}],
  :validate_array_size  => proc {|v| v.size == 3 }
}

valid_input = {
  :id     => 123,
  :name   => "Harry",
  :age    => 21,
  :admin  => true,
  :mails  => ["foo@example.com", "bar@example.com"],
  :other  => {
    :country      => "Denmark",
    :country_code => 12,
    :random       => "foobar"
  },
  :result => "ok",
  :bool => true,
  :validate_array => [
    {:name => "John"},
    {:name => "Coltrane"}
  ],
  :validate_array_size => [1,2,3]
}

invalid_input = {
  :id     => "whatevz",
  :name   => 42,
  :age    => 12,
  :admin  => :maybe,
  :mails  => ["foo@example.com", 1234],
  :other => {
    :country      => [1,2,3],
    :country_code => (1..2),
    :random       => "nothing here"
  },
  :result => "error",
  :bool => false,
  :validate_array => [
    {:name => "John"},
    {:name => 1234}
  ],
  :validate_array_size => [1,2]
}

h = Hashidator.new(schema)
p h.validate(valid_input)     #=> true
p h.validate(invalid_input)   #=> false
