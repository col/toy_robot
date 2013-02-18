require 'point'

class Robot

  attr_reader :position, :direction

  DIRECTIONS = %W(NORTH EAST SOUTH WEST)
  DIRECTIONAL_MOVEMENT = {
      'NORTH' => Point.new(0,1),
      'EAST' => Point.new(1,0),
      'SOUTH' => Point.new(0,-1),
      'WEST' => Point.new(-1,0)
  }
  VALID_COMMANDS = %w(MOVE LEFT RIGHT REPORT)
  TABLE_WIDTH = 5
  TABLE_HEIGHT = 5

  def execute(command)
    return if command.nil? || command.length == 0
    if command =~ /PLACE\s\d,\d,(NORTH|EAST|SOUTH|WEST)/
      place(command[6].to_i, command[8].to_i, command[10..-1])
    else
      command = command.split(' ').first
      self.send(command.downcase) if VALID_COMMANDS.include? command
    end
  end

  def place(x, y, direction)
    new_position = Point.new(x, y)
    return unless valid_direction?(direction) && valid_position?(new_position)
    self.position = new_position
    self.direction = direction
    true
  end

  def move
    return unless on_table?
    new_position = try_move
    return unless valid_position?(new_position)
    self.position = new_position
    true
  end

  def left
    return unless on_table?
    index = DIRECTIONS.index(self.direction)
    self.direction = DIRECTIONS.rotate(-1)[index]
    true
  end

  def right
    return unless on_table?
    index = DIRECTIONS.index(self.direction)
    self.direction = DIRECTIONS.rotate[index]
    true
  end

  def report
    return unless on_table?
    "Output: #{position.x},#{position.y},#{direction}"
  end

  private

  attr_writer :position, :direction

  def on_table?
    position && valid_position?(position)
  end

  def valid_direction?(direction)
    DIRECTIONS.include? direction
  end

  def valid_position?(point)
    return if point.x.nil? || point.y.nil?
    point.x >= 0 && point.x < TABLE_WIDTH && point.y >= 0 && point.y < TABLE_HEIGHT
  end

  def try_move
    position + DIRECTIONAL_MOVEMENT[self.direction]
  end

end