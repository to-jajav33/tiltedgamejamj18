extends Node2D

# Declare member variables here. Examples:
var level1Class = preload("res://test/javi/levels/Level.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true);
	pass # Replace with function body.

func _input(event : InputEvent):
	if !(event is InputEventMouseMotion):
		var level1Inst = level1Class.instance();
		get_parent().add_child(level1Inst);
		queue_free();
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
