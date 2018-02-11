Each with each

```ruby
class FibonacciNumbers
  NUMBERS = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

	def each
      NUMBERS.each {|number| yield(number)}
  end
end

f = FibonacciNumbers.new
f.each do |fibonacci_number|
  puts "A Fibonacci number multiplied by 10: #{fibonacci_number * 10}"
end
```

Each without each

```ruby
class FibonacciNumbers
  NUMBERS = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

  def each
      for i in 0..((NUMBERS.length) - 1)
        yield(NUMBERS[i])
      end
    end
end

f = FibonacciNumbers.new
f.each do |fibonacci_number|
  puts "A Fibonacci number multiplied by 10: #{fibonacci_number * 10}"
end
```

Each without each without yield

```ruby
class FibonacciNumbers
  NUMBERS = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

  def each (&block)
    for i in 0..((NUMBERS.length) - 1)
      block.call(NUMBERS[i])
    end
  end
end

f = FibonacciNumbers.new
f.each { |fibonacci_number| puts fibonacci_number * 10 }
```

Each without each without yield without block

```ruby
class FibonacciNumbers
  NUMBERS = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

  def each (lambda)
    for i in 0..((NUMBERS.length) - 1)
      lambda.call(NUMBERS[i])
    end
  end
end

f = FibonacciNumbers.new
f.each(->(fibonacci_number) { puts fibonacci_number * 10 }
```

Classless each without each without yield without block

```ruby
fibs = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

each = ->(array, lambda) {
  for i in 0..(array.length - 1)
    lambda.call(array[i])
  end
}

each.call(fibs, ->(fib) { puts fib * 10 })
```

Welcome to functional programming

```javascript
var fibs = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

function each (array, fun) {
  for (i = 0; i < array.length; i++) {
    fun(array[i])
  }
}

each(fibs, function (fib) { console.log(fib * 10) })
```

es2015

```javascript
const fibs = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

function each (array, fun) {
  for (i = 0; i < array.length; i++) {
    fun(array[i])
  }
}

each(fibs, fib => console.log(fib * 10))
```

A method is available...

```javascript
const fibs = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]

fibs.forEach(fib => console.log(fib * 10))
```
