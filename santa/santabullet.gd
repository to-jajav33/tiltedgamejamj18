extends RigidBody2D

const Explosion = preload("res://components/explosion/explosion.tscn")


func _ready():
	angular_velocity = rand_range(-4*PI, 4*PI)
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_SantaBullet_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()
	
	var e = Explosion.instance()
	e.global_position = global_position
	get_tree().current_scene.add_child(e)
	
	queue_free()
