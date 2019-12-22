extends KinematicBody2D

var alive = true
var health = 1000
var SPEED = 300

export var state : String


func _ready():
	$AnimationPlayer.play("idle")


func hurt(amount : int = 1):
	if not alive:
		return
		
	$Tween.interpolate_property($Sprite, 'modulate', Color(1,1,1,1), Color(10,1,1,1), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	$Tween.interpolate_property($Sprite, 'modulate', Color(10,1,1,1), Color(1,1,1,1), 0.01, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.01)
	$Tween.start()
	
	health -= amount
	if health <= 0:
		alive = false
		health = 0
		queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("awake")
		$AnimationPlayer.queue("chase")


func _physics_process(delta):
	var player = get_tree().get_nodes_in_group("player")[0]
	
	if state == "idle":
		pass
		
	if state == "awake":
		pass
		
	if state == "chase":
		var direction = global_position.direction_to(player.global_position)
		move_and_slide(direction * SPEED)
		
		
func change_state():
	state = $AnimationPlayer.current_animation
	print(state)
	