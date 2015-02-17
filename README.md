# Little math pet

[![Build Status](https://travis-ci.org/vrinek/little-math-pet.svg?branch=master)](https://travis-ci.org/vrinek/little-math-pet)

This is a simple math parser. It always returns in Float.

## Examples

```ruby
LittleMathPet.new("5*12+8").calc # => 68.0
LittleMathPet.new("5*(12+8)").calc # => 100.0
LittleMathPet.new("60-20%").calc # => 48.0

# It also can handle variables
LittleMathPet.new("5*a+8").calc(:a => 4) # => 28.0
LittleMathPet.new("a*b+c^d").calc(:a => 4, :b => 3, :c => 2, :d => 5) # => 44.0
```

## Syntax

Mostly ruby (+ - * / ** and ()) but can also accept `:` and `÷` for division, `×` (that's a unicode character, not the lowercase X) for multiplication, `^` for exponents, `[]` and `{}` for bracketing. It will also not mind about spaces.

## Changelog

0.1 - Supports addition/subtraction, multiplication/division, exponents and brackets in their correct order.

0.2 - Supports percentage calculations.

0.3 - Nested parentheses

0.4 - Add support for `{}` and a couple more operators

0.5 - General housekeeping (update README, get rid of Jeweler, more travis testing)

## Contributing to little-math-pet

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Kostas Karachalios. See LICENSE.txt for
further details.
