require 'spec_helper'

describe Robot do
  before(:each) { @robot = Robot.new }
  subject { @robot }

  it { should respond_to :place }
  it { should respond_to :move }
  it { should respond_to :left }
  it { should respond_to :right }
  it { should respond_to :report }

  context "before being placed on the table" do
    it "should not move" do
      @robot.move.should be_false
    end
    it "should not turn left" do
      @robot.left.should be_false
    end
    it "should not turn right" do
      @robot.right.should be_false
    end
    it "should not report" do
      @robot.report.should be_false
    end
  end

  context "when placed in the middle of the table (2,2,NORTH)" do
    before :each do
      @robot.place(2,2,'NORTH')
    end
    it "should be on the table" do
      @robot.should be_on_table
    end
    it "should be able to move" do
      @robot.move.should be_true
    end
    it "should be able to turn left" do
      @robot.left.should be_true
    end
    it "should be able to turn right" do
      @robot.right.should be_true
    end
    it "should report it's current position as '2,2,NORTH'" do
      @robot.report.should eql 'Output: 2,2,NORTH'
    end

    describe "can move in all directions" do
      it "can move NORTH" do
        @robot.move
        @robot.position.should == Point.new(2,3)
      end
      it "can move EAST" do
        @robot.right
        @robot.move
        @robot.position.should == Point.new(3, 2)
      end
      it "can move SOUTH" do
        @robot.right
        @robot.right
        @robot.move
        @robot.position.should == Point.new(2, 1)
      end
      it "can move WEST" do
        @robot.left
        @robot.move
        @robot.position.should == Point.new(1, 2)
      end
    end
  end

  describe "cannot move off the edge of the table" do
    it "cannot move off the front of the table" do
      @robot.place(2,0,'SOUTH')
      @robot.move
      @robot.position.should == Point.new(2,0)
    end
    it "cannot move off the back of the table" do
      @robot.place(2, 4, 'NORTH')
      @robot.move
      @robot.position.should == Point.new(2, 4)
    end
    it "cannot move off the left side of the table" do
      @robot.place(0, 2, 'WEST')
      @robot.move
      @robot.position.should == Point.new(0, 2)
    end
    it "cannot move off the right side of the table" do
      @robot.place(4, 2, 'EAST')
      @robot.move
      @robot.position.should == Point.new(4, 2)
    end
  end

  describe "#place" do
    context "given valid params" do
      before(:each) { @robot.place(3, 3, 'WEST') }
      it { should be_on_table }
      its(:position) { should == Point.new(3, 3) }
      its(:direction) { should == 'WEST' }
    end
    context "given an invalid position" do
      before(:each) { @robot.place(5, 5, 'WEST') }
      it { should_not be_on_table }
      its(:position) { should be_nil }
      its(:direction) { should be_nil }
    end
    context "given an invalid direction" do
      before(:each) { @robot.place(3, 3, 'RIGHT') }
      it { should_not be_on_table }
      its(:position) { should be_nil }
      its(:direction) { should be_nil }
    end
  end

  describe "#left" do
    @values = {
        'NORTH' => 'WEST',
        'WEST' => 'SOUTH',
        'SOUTH' => 'EAST',
        'EAST' => 'NORTH'
    }
    @values.each_pair do |start, result|
      it "should change direction from #{start} to #{result} when turning left" do
        @robot.place(0, 0, start)
        @robot.left
        @robot.direction.should == result
      end
    end
  end

  describe "#right" do
    @values = {
        'NORTH' => 'EAST',
        'EAST' => 'SOUTH',
        'SOUTH' => 'WEST',
        'WEST' => 'NORTH'
    }
    @values.each_pair do |start, result|
      it "should change direction from #{start} to #{result} when turning right" do
        @robot.place(0, 0, start)
        @robot.right
        @robot.direction.should == result
      end
    end
  end

  describe "#execute" do
    it "should call place when executing a valid command" do
      @robot.should_receive(:place).with(1, 1, 'NORTH')
      @robot.execute('PLACE 1,1,NORTH')
    end
    it "should not call place when executed with an invalid coordinate" do
      @robot.should_not_receive(:place)
      @robot.execute('PLACE x,1,NORTH')
    end
    it "should not call place when executed with an invalid direction" do
      @robot.should_not_receive(:place)
      @robot.execute('PLACE 1,1,LEFT')
    end
    it "should call move when executing 'MOVE'" do
      @robot.should_receive(:move)
      @robot.execute('MOVE')
    end
    it "should be case sensitive" do
      @robot.should_not_receive(:move)
      @robot.execute('move')
    end
    it "should call left when executing 'LEFT'" do
      @robot.should_receive(:left)
      @robot.execute('LEFT')
    end
    it "should call left when executing 'RIGHT'" do
      @robot.should_receive(:right)
      @robot.execute('RIGHT')
    end
    it "should call left when executing 'REPORT'" do
      @robot.should_receive(:report)
      @robot.execute('REPORT')
    end
  end

  describe "#report" do
    it "should report the location of the robot in the format 'Output: x, y, direction'" do
      @robot.place(1,1,'NORTH')
      @robot.report.should == 'Output: 1,1,NORTH'
    end
    it "should report nothing when the robot has not been placed " do
      @robot.report.should be_nil
    end
  end
end