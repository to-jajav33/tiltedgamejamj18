extends KinematicBody2D

const SPEED = 640
const DEADZONE = 0.2
const BULLET_FORCE = 2500

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
		
	var move_dir = Vector2(x,y).normalized()
	
	move_and_slide(move_dir * SPEED)
	
	# Aiming - right stick
	x = Input.get_joy_axis(0,2)
	y = Input.get_joy_axis(0,3)
	
	if abs(x) <= DEADZONE:
		x = 0
	if abs(y) <= DEADZONE:
		y = 0

	var aim_dir = Vector2(x,y).normalized()
	if aim_dir.length() > 0:
		$gun.rotation = Vector2(1,0).angle_to(aim_dir)
	
	if Input.is_action_pressed("shoot") and $shootCooldown.is_stopped():
		$shootCooldown.start()
		
		var b = Bullet.instance()
		get_tree().current_scene.add_child(b)
		b.global_position = global_position + Vector2(128,0).rotated($gun.rotation)
		b.rotation = $gun.rotation
		b.apply_impulse(Vector2(0,0), Vector2(1,0).rotated($gun.rotation) * BULLET_FORCE)
