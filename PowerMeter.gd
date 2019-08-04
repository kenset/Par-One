extends Node2D

export var SPEED = 3

var pause_progress = false
var direction = 1

signal power_level_selected

func _ready():
	self.set_process(true)

func _process(delta):
	if (!pause_progress):
		if ($ProgressBar.value >= $ProgressBar.max_value || $ProgressBar.value <= $ProgressBar.min_value):
			direction *= -1
		$ProgressBar.value += ((SPEED * max($ProgressBar.value, 10) * direction) * delta)

func _on_golf_ball_hit():
	pause_progress = true
	var power_level = $ProgressBar.value
	emit_signal("power_level_selected", power_level)

func _on_reset_power_meter():
	$ProgressBar.value = 0
	pause_progress = false
	direction = 1