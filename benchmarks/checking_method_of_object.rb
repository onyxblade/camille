require "benchmark/ips"

class A
  def m
  end
end

a = A.new

Benchmark.ips do |x|
  x.report("respond_to?") do
    a.respond_to? :m
  end

  x.report("calling method") do
    a.m
  end

  x.compare!
end