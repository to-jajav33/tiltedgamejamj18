extends RigidBody2D

func _ready():
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_SantaBullet_body_entered(body):
	queue_free()
