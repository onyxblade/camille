require "benchmark/ips"

class A
end

a = A.new

Benchmark.ips do |x|
  x.report("instance_of?") do
    a.instance_of? A
  end

  x.report("is_a?") do
    a.is_a? A
  end

  x.report("class ==") do
    a.class == A
  end

  x.report("class.equal?") do
    a.class.equal?(A)
  end

  x.compare!
end