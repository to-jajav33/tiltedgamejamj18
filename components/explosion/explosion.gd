extends Node2D

func _ready():
	$Timer.wait_time = $Particles2D.lifetime
	$Timer.start()
	$Particles2D.emitting = true


func _on_Timer_timeout():
	queue_free()
