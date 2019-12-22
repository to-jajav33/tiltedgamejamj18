extends KinematicBody2D

# Declare member variables here. Examples:
export var isHorizonatalMovement : bool = true;
export var maxDistTraveled : float = 10.0;
export var speedOfTravel : float = 2.0;


var __startPos : Vector2 = Vector2();
var __currentDirection : int = -1; # 0 = left or up; +1 = right or down;
var __currVel : Vector2 = Vector2();

# Called when the node enters the scene tree for the first time.
func _ready():
	__startPos = self.position;
	set_physics_process(true);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	self.__currVel = Vector2.ZERO;
	var dir = Vector2.RIGHT;
	if (self.isHorizonatalMovement):
		dir = Vector2.RIGHT;
	else:
		dir = Vector2.DOWN;
		
	self.__currVel = self.__currVel + ((dir * __currentDirection) * speedOfTravel * delta);
	move_and_slide(self.__currVel);
	
	if (self.position.distance_to(self.__startPos) >= self.maxDistTraveled):
		self.__currentDirection = -(self.__currentDirection);
	return;
