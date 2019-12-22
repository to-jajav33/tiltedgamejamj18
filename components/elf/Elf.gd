extends KinematicBody2D

export var SPEED : int = 500
export var health : int = 2

var player
var chase = false
var alive = true


func _ready():
	player = get_tree().get_nodes_in_group("player")[0]
	
	
func _physics_process(delta):
	if chase:
		var direction = global_position.direction_to(player.global_position)
		move_and_slide(direction * SPEED)
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if collision.collider.is_in_group("player"):
				collision.collider.hurt()
		if direction.length() == 0:
			$Sprite.play("idle")
		
		if direction.x < 0 and not $Sprite.flip_h:
			$Sprite.play("walk")
			$Sprite.flip_h = true
			
		if direction.x > 0 and $Sprite.flip_h:
			$Sprite.play("walk")
			$Sprite.flip_h = false
			
		for i in range(get_slide_count()):
			$Sprite.play("attack")
			var collision = get_slide_collision(i)
			if collision.collider.has_method("hurt"):
				collision.collider.hurt()

	
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		chase = true


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
	