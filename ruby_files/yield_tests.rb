bob = [1,2,3,4,5,6]
# bob = ["harry", "alison", "greg"]

def bob.inject(default = nil)
    accumulator = default || self[0]
    if default
      self.each do |element|
        accumulator = yield(accumulator, element)
      end
    else
      self.drop(1).each do |element|
        accumulator = yield(accumulator, element)
      end
    end
    puts "all adds up to: " # just to prove it's this method being called, not the superclasses...
    p accumulator
end

bob.inject({}) {|a,e| a[e] = "x"*e; a}

