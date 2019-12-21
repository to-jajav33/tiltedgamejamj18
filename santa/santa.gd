extends KinematicBody2D

const SPEED = 350
const DEADZONE = 0.2
const BULLET_FORCE = 1000

const Bullet = preload("res://santa/santabullet.tscn")


func _ready():
	pass


func _physics_process(delta):
	# Moving - left stick
	var x = Input.get_joy_axis(0,0)
	var y = Input.get_joy_axis(0,1)
	
	if abs(x) <= DEADZONE:
		x = 0
	if abs(y) <= DEADZONE:
		y = 0

	if x < 0:
		$body.flip_v = true
	if x > 0:
		$body.flip_v = false
		
	move_and_slide(Vector2(x,y) * SPEED)
	
	# Aiming - right stick
	x = Input.get_joy_axis(0,2)
	y = Input.get_joy_axis(0,3)
	
	if abs(x) <= DEADZONE:
		x = 0
	if abs(y) <= DEADZONE:
		y = 0

	$gun.rotation = Vector2(1,0).angle_to(Vector2(x,y))
	
	if Input.is_action_pressed("shoot"):
		var b = Bullet.instance()
		get_tree().current_scene.add_child(b)
		b.global_position = global_position
		b.apply_impulse(Vector2(0,0), Vector2(1,0).rotated($gun.rotation) * BULLET_FORCE)
