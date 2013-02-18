# Toy Robot Simulator

## Description
This app simulates a toy robot moving around on a 5x5 table. It can be run in interactive mode or take input commands from a file.

### Valid Commands:

```
PLACE X,Y,DIRECTION 
MOVE 
LEFT 
RIGHT 
REPORT  
```

X and Y should be between 0 and 4.
 
DIRECTION should be NORTH, SOUTH, EAST or WEST
 

## Setup
``` 
bundle install
```

## Usage
```
./bin/robot_simulator [input_file]
```

## Tests
```
rspec
```
