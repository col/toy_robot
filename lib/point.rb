class Point < Struct.new(:x, :y)
  def +(other)
    Point.new(x + other.x, y + other.y)
  end
end