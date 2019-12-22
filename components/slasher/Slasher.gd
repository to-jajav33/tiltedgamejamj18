extends KinematicBody2D

# Declare member variables here. Examples:
export var isHorizonatalMovement : bool = true;
export var maxDistTraveled : float = 10.0;
export var speedOfTravel : float = 2.0;
export var sizeOfHearing : float = 2048;
export var health : int = 5;

var alive = true


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
	self.__startPos = self.position;
	get_node("Area2D/CollisionShape2D").shape.radius = self.sizeOfHearing;
	
	set_physics_process(true);
	
	$Sprite.play("idle")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	self.__currVel = Vector2.ZERO;
	var dir = Vector2.RIGHT;
	if (self.__chase_state == STATE_CHASE.CHASE):
		self.__currVel = Vector2.ZERO;
		if (self.__chaseTarget):
			var myRaycast = get_node("RayCast2D");
			myRaycast.cast_to = to_local(self.__chaseTarget.global_position);
			if (myRaycast.is_colliding() && (myRaycast.get_collider() == self.__chaseTarget)):
				dir = self.global_position.direction_to(self.__chaseTarget.global_position);
				self.__currVel = self.__currVel + (dir * speedOfTravel);
				if (self.position.distance_to(self.__startPos) > self.maxDistTraveled) || (!self.__chaseTarget):
					self.__chase_state = STATE_CHASE.COMMING_BACK_HOME;
				else:
					self.__startPos = self.position;
					move_and_slide(self.__currVel);
	
	if(self.__chase_state == STATE_CHASE.COMMING_BACK_HOME):
		self.__currVel = Vector2.ZERO;
		if (self.position != self.__startPos):
			dir = self.position.direction_to(self.__startPos);
			self.__currVel = self.__currVel + (dir * speedOfTravel);
	
			var futurePos : Vector2 = (self.position + self.__currVel);
			if (self.position.distance_to(self.__startPos) < ((self.speedOfTravel * delta))):
				self.__chase_state = STATE_CHASE.PATROLING;
				self.position = self.__startPos;
			else:
				if (futurePos.distance_to(self.__startPos) > self.maxDistTraveled) || (self.position.distance_to(self.__startPos) > self.maxDistTraveled):
					move_and_slide(self.__currVel);
		else:
			self.__chase_state = STATE_CHASE.PATROLING;
	
	elif(self.__chase_state == STATE_CHASE.PATROLING):
		self.__currVel = Vector2.ZERO;
		if (self.isHorizonatalMovement):
			dir = Vector2.RIGHT;
		else:
			dir = Vector2.DOWN;
			
		self.__currVel = self.__currVel + ((dir * __currentDirection) * speedOfTravel);
		move_and_slide(self.__currVel);
		
		if (self.position.distance_to(self.__startPos) >= self.maxDistTraveled):
			self.__currentDirection = -(self.__currentDirection);
	
	if (self.__chaseTarget):
		if (self.global_position.distance_to(self.__chaseTarget.global_position) < self.sizeOfHearing):
			self.__chase_state = STATE_CHASE.CHASE;
			
	if __currVel.length() == 0:
		$Sprite.play("idle")
		
	if __currVel.x < 0 and not $Sprite.flip_h:
		$Sprite.play("walk")
		$Sprite.flip_h = true
		
	if __currVel.x > 0 and $Sprite.flip_h:
		$Sprite.play("walk")
		$Sprite.flip_h = false
		
	for i in range(get_slide_count()):
		$Sprite.play("attack")
		var collision = get_slide_collision(i)
		if collision.collider.has_method("hurt"):
			collision.collider.hurt()
		
	return;


func _on_Area2D_body_entered(body):
	if (body.is_in_group("player")):
		self.__chase_state = STATE_CHASE.CHASE;
		self.__chaseTarget = body;
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	if (body == self.__chaseTarget):
		self.__chase_state = STATE_CHASE.COMMING_BACK_HOME;
		self.__chaseTarget = null;
	pass # Replace with function body.


func hurt(amount : int = 1):
	if not alive:
		return
		
	$Tween.interpolate_property($Sprite, 'modulate', Color(1,1,1,1), Color(10,10,10,1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.interpolate_property($Sprite, 'modulate', Color(10,10,10,1), Color(1,1,1,1), 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.01)
	$Tween.start()

	health -= amount
	if health <= 0:
		health = 0
		alive = false
		queue_free()
