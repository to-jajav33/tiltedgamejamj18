extends StaticBody2D

var component_type = "DOOR"

func _ready():
	pass


func get_component_type():
	return component_type


func _on_Area2D_area_entered(area):
	if area.has_method("get_component_type"):
		if area.get_component_type() == "KEY":
			area.queue_free()
			queue_free()
