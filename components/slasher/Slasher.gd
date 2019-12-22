extends KinematicBody2D

# Declare member variables here. Examples:
export var isHorizonatalMovement : bool = true;
export var maxDistTraveled : float = 10.0;
export var speedOfTravel : float = 2.0;
export var sizeOfHearing : float = 2048;

enum STATE_CHASE {
	PATROLING,
	CHASE,
	COMMING_BACK_HOME,
};

var __startPos : Vector2 = Vector2();
var __currentDirection : int = -1; # 0 = left or up; +1 = right or down;
var __currVel : Vector2 = Vector2();
var __chase_state : int = STATE_CHASE.PATROLING;
var __chaseTarget = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	__startPos = self.position;
	get_node("Area2D/CollisionShape2D").shape.radius = self.sizeOfHearing;
	
	set_physics_process(true);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	self.__currVel = Vector2.ZERO;
	var dir = Vector2.RIGHT;
	if (self.__chase_state == STATE_CHASE.CHASE):
		if (self.__chaseTarget):
			var myRaycast = get_node("RayCast2D");
			myRaycast.cast_to = to_local(self.__chaseTarget.global_position);
			if (myRaycast.is_colliding() && myRaycast.get_collider() == self.__chaseTarget):
				dir = self.global_position.direction_to(self.__chaseTarget.global_position);
				self.__currVel = self.__currVel + (dir * speedOfTravel * delta);
		
		if (self.position.distance_to(self.__startPos) >= self.maxDistTraveled) || (!self.__chaseTarge):
			self.__chase_state = STATE_CHASE.COMMING_BACK_HOME;
	
	if(self.__chase_state == STATE_CHASE.COMMING_BACK_HOME):
		if (self.position != self.__startPos):
			dir = self.position.direction_to(self.__startPos);
			self.__currVel = self.__currVel + ((dir * __currentDirection) * speedOfTravel * delta);
			
			var futurePos : Vector2 = (self.position + self.__currVel);
			if (futurePos.distance_to(self.__startPos) > (speedOfTravel * delta)):
				move_and_slide(self.__currVel);
			else:
				self.position = self.__startPos;
	else:
		if (self.isHorizonatalMovement):
			dir = Vector2.RIGHT;
		else:
			dir = Vector2.DOWN;
			
		self.__currVel = self.__currVel + ((dir * __currentDirection) * speedOfTravel * delta);
		move_and_slide(self.__currVel);
		
		if (self.position.distance_to(self.__startPos) >= self.maxDistTraveled):
			self.__currentDirection = -(self.__currentDirection);
	return;


func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		self.__chaseTarget = body;
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if (body == self.__chaseTarget):
		self.__chaseTarget = null;
	pass # Replace with function body.
