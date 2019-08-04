extends Node2D

signal score_points

export(Array, PackedScene) var courses

var currentCourseNumber = 0
var currentCourse: Node2D

func _ready():
	loadCourse(currentCourseNumber)

func loadNextCourse():
	currentCourseNumber = currentCourseNumber + 1
	if (currentCourseNumber < courses.size()):
		currentCourse.queue_free()
		loadCourse(currentCourseNumber)

func loadCourse(courseNumber):
	currentCourse = courses[courseNumber].instance()
	currentCourse.set_global_transform($ScreenCenter.get_global_transform())
	add_child(currentCourse)
	
	var golfBall: Node2D = currentCourse.get_node("GolfBall")
	var hole: Node2D = currentCourse.get_node("Hole")
	
	golfBall.connect("golf_ball_hit", $PowerMeter, "_on_golf_ball_hit")
	$PowerMeter.connect("power_level_selected", golfBall, "_on_power_level_selected")
	
	$Timer/Timer.connect("timeout", self, "_on_timeout")
	hole.connect("hole_in_one", golfBall, "_on_hole_in_one")
	
	self.connect("score_points", $HighScore, "_on_score_points")
	golfBall.connect("score_points", $HighScore, "_on_score_points")
	hole.connect("score_points", $HighScore, "_on_score_points")

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