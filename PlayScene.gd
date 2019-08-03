extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$GolfBall.connect("golf_ball_hit", $PowerMeter, "_on_golf_ball_hit")
	$PowerMeter.connect("power_level_selected", $GolfBall, "_on_power_level_selected")
	$Timer/Timer.connect("timeout", self, "_on_timeout")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_timeout():
	get_tree().reload_current_scene()