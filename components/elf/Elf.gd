extends KinematicBody2D

var player
var SPEED = 500
var chase = false


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
	
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		chase = true


func hurt(amount : int = 1):
	queue_free()
	