extends KinematicBody2D

export var health : int = 100
export var SPEED : int = 200

var state : String
var alive = true


func _ready():
	$AnimationPlayer.play("idle")


func hurt(amount : int = 1):
	if not alive:
		return
		
	if state != "awake" and state != "chase":
		$AnimationPlayer.play("awake")
		$AnimationPlayer.queue("chase")

	$Tween.interpolate_property($Sprite, 'modulate', Color(1,1,1,1), Color(10,10,10,1), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.interpolate_property($Sprite, 'modulate', Color(10,10,10,1), Color(1,1,1,1), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.01)
	$Tween.start()
	
	health -= amount
	if health <= 0:
		alive = false
		health = 0
		queue_free()


func _physics_process(delta):
	var player = get_tree().get_nodes_in_group("player")[0]
	
	if state == "idle":
		$Sprite.play("idle")
		pass
		
	if state == "awake":
		pass
		
	if state == "chase":
		$Sprite.play("walk")
			
	if state == "attack":
		$Sprite.play("attack")
		
	if state == "chase" or state == "attack":
		var direction = global_position.direction_to(player.global_position)
		move_and_slide(direction * SPEED)
		
		if direction.x < 0 and not $Sprite.flip_h:
			$Sprite.flip_h = true
			
		if direction.x > 0 and $Sprite.flip_h:
			$Sprite.flip_h = false
			
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.has_method("hurt"):
			$AnimationPlayer.play("attack")
			$AnimationPlayer.queue("chase")
			collision.collider.hurt()


func change_state():
	state = $AnimationPlayer.current_animation
	