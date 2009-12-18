schema = {
  :id     => Integer,
  :name   => String,
  :age    => (13..99),
  :admin  => Boolean,
  :mails  => [String],
  :other  => {
    :language => String,
    :country  => String
  }
}

valid_input = {
  :id     => 123,
  :name   => "Harry",
  :age    => 21,
  :admin  => true,
  :mails  => ["foo@example.com", "bar@example.com"],
  :other  => {
    :language => "Danish",
    :country  => "Denmark"
  }
}

invalid_input = {
  :id     => "whatevz",
  :name   => 42,
  :age    => 12,
  :admin  => :maybe,
  :mails  => ["foo@example.com", 1234],
  :other => {
    :language => true,
    :country  => [1,2,3]
  }
}

Hashidator.validate(schema, valid_input) #=> true

Hashidator.validate(schema, invalid_input) #=> false
