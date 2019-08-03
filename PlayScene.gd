extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$GolfBall.connect("golf_ball_hit", $PowerMeter, "_on_golf_ball_hit")
	$PowerMeter.connect("power_level_selected", $GolfBall, "_on_power_level_selected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass