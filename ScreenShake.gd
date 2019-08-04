extends Node2D

export var SHAKE_AMOUNT = 0.0

func _ready():
	$Timer.connect("timeout", self, "_on_timeout")
	randomize()

func _process(delta):
	$Camera2D.set_offset(Vector2(rand_range(-1.0, 1.0) * SHAKE_AMOUNT, 
		rand_range(-1.0, 1.0) * SHAKE_AMOUNT))

func _on_screen_shake(amount, duration):
	$Timer.start(duration)
	SHAKE_AMOUNT = amount

func _on_timeout():
	SHAKE_AMOUNT = 0.0