extends Node2D

signal score_points

export(Array, PackedScene) var courses

var currentCourseNumber = 0
var currentCourse

func _ready():
	$GolfBall.connect("golf_ball_hit", $PowerMeter, "_on_golf_ball_hit")
	$PowerMeter.connect("power_level_selected", $GolfBall, "_on_power_level_selected")
	$Timer/Timer.connect("timeout", self, "_on_timeout")
	$Hole.connect("hole_in_one", $GolfBall, "_on_hole_in_one")
	
	self.connect("score_points", $HighScore, "_on_score_points")
	$GolfBall.connect("score_points", $HighScore, "_on_score_points")
	$Hole.connect("score_points", $HighScore, "_on_score_points")
	
	loadCourse(currentCourseNumber)

func loadNextCourse():
	currentCourse.queue_free()
	currentCourseNumber = currentCourseNumber + 1
	loadCourse(currentCourseNumber)

func loadCourse(courseNumber):
	currentCourse = courses[courseNumber].instance()
	currentCourse.set_global_transform($ScreenCenter.get_global_transform())
	add_child(currentCourse)

#func _process(delta):
#	pass

func _on_timeout():
	calculate_score()
	loadNextCourse()
#	get_tree().reload_current_scene()

func calculate_score():
	if ($GolfBall == null):
		return
	var golfBallPosition = $GolfBall/CollisionShape2D.get_global_transform().get_origin()
	var holePosition = $Hole.get_global_transform().get_origin()
	var distance = golfBallPosition.distance_to(holePosition)
	emit_signal("score_points", floor(distance))