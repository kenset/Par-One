extends Node2D

signal score_points

# Called when the node enters the scene tree for the first time.
func _ready():
	$GolfBall.connect("golf_ball_hit", $PowerMeter, "_on_golf_ball_hit")
	$PowerMeter.connect("power_level_selected", $GolfBall, "_on_power_level_selected")
	$Timer/Timer.connect("timeout", self, "_on_timeout")
	
	self.connect("score_points", $HighScore, "_on_score_points")
	$GolfBall.connect("score_points", $HighScore, "_on_score_points")
	$Hole.connect("score_points", $HighScore, "_on_score_points")

#func _process(delta):
#	pass

func _on_timeout():
	calculate_score()
#	get_tree().reload_current_scene()

func calculate_score():
	var golfBallPosition = $GolfBall/CollisionShape2D.get_global_transform().get_origin()
	var holePosition = $Hole.get_global_transform().get_origin()
	var distance = golfBallPosition.distance_to(holePosition)
	emit_signal("score_points", floor(distance))