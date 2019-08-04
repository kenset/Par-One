extends Node2D

signal score_points
signal reset_power_meter

export(Array, PackedScene) var courses

var currentCourseNumber = 0
var currentCourse: Node2D

func _ready():
	self.connect("reset_power_meter", $PowerMeter, "_on_reset_power_meter")
	loadCourse(currentCourseNumber)

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode != KEY_SPACE:
		if (event.scancode - 49 < courses.size()):
			currentCourse.queue_free()
			loadCourse(event.scancode - 49)

func loadNextCourse():
	currentCourseNumber = currentCourseNumber + 1
	if (currentCourseNumber < courses.size()):
		loadCourse(currentCourseNumber)

func loadCourse(courseNumber):
	if (courseNumber < 0 || courseNumber >= courses.size()):
		return
	if (currentCourse != null):
		currentCourse.queue_free()
	emit_signal("reset_power_meter")
	
	currentCourse = courses[courseNumber].instance()
	currentCourse.set_global_transform($ScreenCenter.get_global_transform())
	add_child(currentCourse)
	
	var golfBall: Node2D = currentCourse.get_node("GolfBall")
	var hole: Node2D = currentCourse.get_node("Hole")
	
	golfBall.connect("golf_ball_hit", $PowerMeter, "_on_golf_ball_hit")
	golfBall.connect("golf_ball_stopped", self, "_on_golf_ball_stopped")
	$PowerMeter.connect("power_level_selected", golfBall, "_on_power_level_selected")
	
	$Timer/Timer.connect("timeout", self, "_on_timeout")
	hole.connect("hole_in_one", golfBall, "_on_hole_in_one")
	hole.connect("hole_in_one", self, "_on_hole_in_one")
	
	self.connect("score_points", $HighScore, "_on_score_points")
	golfBall.connect("score_points", $HighScore, "_on_score_points")
	hole.connect("score_points", $HighScore, "_on_score_points")

#func _process(delta):
#	pass

func _on_golf_ball_stopped():
	calculate_score()
	loadNextCourse()

func _on_timeout():
	calculate_score()
	loadNextCourse()

func _on_hole_in_one():
	loadNextCourse()

func calculate_score():
	if ($GolfBall == null):
		return
	var golfBallPosition = $GolfBall/CollisionShape2D.get_global_transform().get_origin()
	var holePosition = $Hole.get_global_transform().get_origin()
	var distance = golfBallPosition.distance_to(holePosition)
	emit_signal("score_points", floor(distance))