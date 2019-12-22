extends StaticBody2D

func _ready():
	pass


func _on_Area2D_area_entered(area):
	if area.is_in_group("keys"):
		area.queue_free()
		queue_free()
