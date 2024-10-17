require "benchmark/ips"

def array_object
  [1, 2, 3]
end

def hash_object
  {
    a: 1,
    b: 2,
    c: 3
  }
end

class PlainObject
  attr_reader :a, :b, :c

  def initialize a, b, c
    @a = a
    @b = b
    @c = c
  end
end

def plain_object
  PlainObject.new(1, 2, 3)
end

StructObject = Struct.new(:a, :b, :c)

def struct_object
  StructObject.new(1, 2, 3)
end

DataObject = Data.define(:a, :b, :c)

def data_object
  DataObject.new(1, 2, 3)
end

Benchmark.ips do |x|
  x.report("parallel assignment") do
    a, b, c = array_object
  end

  x.report("array access") do
    arr = array_object
    a = arr[0]
    b = arr[1]
    c = arr[2]
  end

  x.report("hash access") do
    hsh = hash_object
    a = hsh[:a]
    b = hsh[:b]
    c = hsh[:c]
  end

  x.report("hash destructuring") do
    hash_object => {a:, b:, c:}
  end

  x.report("plain object") do
    obj = plain_object
    a = obj.a
    b = obj.b
    c = obj.c
  end

  x.report("struct object") do
    obj = struct_object
    a = obj.a
    b = obj.b
    c = obj.c
  end

  x.report("struct object destructuring") do
    struct_object => {a:, b:, c:}
  end

  x.report("data object") do
    obj = data_object
    a = obj.a
    b = obj.b
    c = obj.c
  end

  x.report("data object destructuring") do
    data_object => {a:, b:, c:}
  end

  x.compare!
end