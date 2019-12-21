extends Area2D

var component_type = "KEY"

export var keyID = 1
var follow_player = false

func _ready():
	pass


func _physics_process(delta):
	if follow_player:
		var player = get_tree().current_scene.find_node("Santa")
		if player:
			var vector_to_player = player.global_position - global_position
			if vector_to_player.length() > 128:
				global_position = lerp(global_position, player.global_position, 0.05)


func _on_Key_body_entered(body):
	if body.name == "Santa":
		follow_player = true


func get_component_type():
	return component_type