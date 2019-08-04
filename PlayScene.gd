extends Node2D

signal score_points
signal reset_power_meter

export(Array, PackedScene) var courses
export(Array, PackedScene) var hardCourses
export var SHAKE_AMOUNT = 1.0

var currentCourseNumber = 0
var currentCourse: Node2D
var confetti_scene = preload("res://Confetti.tscn")
var go_to_hard_course = false
var in_hard_course = false

func _ready():
	self.connect("reset_power_meter", $PowerMeter, "_on_reset_power_meter")
	randomize()
	loadCourseWithCourseNumber(currentCourseNumber, courses)

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode != KEY_SPACE:
		if (event.scancode - 49 < courses.size()):
			go_to_hard_course = false
			loadCourseWithCourseNumber(event.scancode - 49, courses)

func _process(delta):
	if (Input.is_action_pressed("hard_modifier")):
		if (Input.is_key_pressed(KEY_1)):
			go_to_hard_course = true
			loadCourseWithCourseNumber(0, hardCourses)

func loadNextCourse():
	currentCourseNumber = currentCourseNumber + 1
	if (currentCourseNumber < courses.size()):
		loadCourseWithCourseNumber(currentCourseNumber, courses)

func loadCourseWithCourseNumber(courseNumber, courses_array):
	if (courseNumber < 0 || courseNumber >= courses_array.size()):
		return
	if (currentCourse != null):
		currentCourse.queue_free()
	emit_signal("reset_power_meter")
	
	var courseToLoad = courses_array[courseNumber].instance()
	loadCourse(courseToLoad)
	if (go_to_hard_course == true):
		in_hard_course = true
	else:
		in_hard_course = false

func loadCourse(course):
	currentCourse = course
	currentCourse.set_global_transform($ScreenCenter.get_global_transform())
	add_child(currentCourse)
	
	var golfBall: Node2D = currentCourse.get_node("GolfBall")
	var hole: Node2D = currentCourse.get_node("Hole")
	var specialHole: Node2D = currentCourse.get_node("SpecialHole")
	
	golfBall.connect("golf_ball_hit", $PowerMeter, "_on_golf_ball_hit")
	golfBall.connect("golf_ball_stopped", self, "_on_golf_ball_stopped")
	golfBall.connect("screen_shake", $ScreenShake, "_on_screen_shake")
	$PowerMeter.connect("power_level_selected", golfBall, "_on_power_level_selected")
	
	$Timer/Timer.connect("timeout", self, "_on_timeout")
	$CelebrationTimer.connect("timeout", self, "_on_celebration_timeout")
	hole.connect("hole_in_one", golfBall, "_on_hole_in_one")
	hole.connect("hole_in_one", self, "_on_hole_in_one")
	if (specialHole != null):
		specialHole.connect("hole_in_one", golfBall, "_on_hole_in_one")
		specialHole.connect("hole_in_one", self, "_on_hole_in_one")
	
	self.connect("score_points", $HighScore, "_on_score_points")
	golfBall.connect("score_points", $HighScore, "_on_score_points")
	hole.connect("score_points", $HighScore, "_on_score_points")
	if (specialHole != null):
		specialHole.connect("score_points", $HighScore, "_on_score_points")
	
	currentCourse.find_node("GolfBall").add_to_group("golfBall")

func _on_celebration_timeout():
	if (go_to_hard_course == true):
		loadCourseWithCourseNumber(0, hardCourses)
	else:
		loadNextCourse()

func _on_golf_ball_stopped():
	go_to_hard_course = false
	calculate_score()
	loadNextCourse()

func _on_timeout():
	calculate_score()
	loadNextCourse()

func _on_hole_in_one(is_special):
	$CelebrationTimer.start()
	var confetti = confetti_scene.instance()
	var confettiPosition = currentCourse.get_node("Hole").get_global_position()
	if (is_special):
		confettiPosition = currentCourse.get_node("SpecialHole").get_global_position()
		go_to_hard_course = true
	else:
		go_to_hard_course = false
	confetti.set_global_position(confettiPosition)
	add_child(confetti)

func calculate_score():
	if ($GolfBall == null):
		return
	var golfBallPosition = $GolfBall/CollisionShape2D.get_global_transform().get_origin()
	var holePosition = $Hole.get_global_transform().get_origin()
	var distance = golfBallPosition.distance_to(holePosition)
	emit_signal("score_points", floor(distance))