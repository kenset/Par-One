extends Node2D

var pause_progress = false
var power_level

signal power_level_selected

func _ready():
	self.set_process(true)

func _process(delta):
	if (!pause_progress):
		$ProgressBar.value += 20 * delta
		power_level = $ProgressBar.value
		

func _on_golf_ball_hit():
	pause_progress = true
	emit_signal("power_level_selected", power_level)
