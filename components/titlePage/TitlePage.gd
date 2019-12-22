extends Node2D

# Declare member variables here. Examples:
var level1Class = preload("res://test/javi/levels/Level.tscn");
var isSpawned = false;
const Bullet = preload("res://santa/santabullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true);
	pass # Replace with function body.

func _input(event : InputEvent):
	if (self.isSpawned):
		return;
	if !(event is InputEventMouseMotion):
		get_tree().change_scene("res://test/javi/levels/Level.tscn");
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
