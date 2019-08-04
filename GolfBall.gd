extends RigidBody2D

export var POWER_MULTIPLIER = 5
export var WALL_POINTS = 10
export var LINEAR_DAMP = 0.25
export var SAND_TRAP_DAMP = 5.0

var golf_ball_has_been_hit = false
var in_sand_trap = false

signal golf_ball_hit
signal golf_ball_stopped
signal screen_shake
signal score_points

func _ready():
	self.connect("body_entered", self, "_on_body_entered")

func _process(delta):
	if ($Arrow.visible):
		$Arrow.look_at(get_global_mouse_position())

func _integrate_forces(state):
	if (in_sand_trap == true):
		self.set_linear_damp(SAND_TRAP_DAMP)
	else :
		self.set_linear_damp(LINEAR_DAMP)
	if (self.linear_velocity.length() < 5 && self.linear_velocity.length() > 0):
		linear_velocity = Vector2(0, 0)
		$AnimatedSprite.playing = false
		emit_signal("golf_ball_stopped")

func _input(event):
	if event is InputEventKey and event.pressed and !golf_ball_has_been_hit:
		if event.scancode == KEY_SPACE:
			hit_golf_ball()

func hit_golf_ball():
	$AnimatedSprite.playing = true
	golf_ball_has_been_hit = true
	emit_signal("golf_ball_hit")

func _on_power_level_selected(power_level):
	$Arrow.hide()
	self.apply_central_impulse((get_global_mouse_position() - self.global_position).normalized() * (power_level * POWER_MULTIPLIER))

func _on_body_entered(body):
	$Audio.play(0.0)
	emit_signal("screen_shake", 1.0, 0.1)
	emit_signal("score_points", WALL_POINTS)

func _on_hole_in_one():
	queue_free()

func _on_entered_sand_trap():
	emit_signal("screen_shake", 1.0, 0.1)
	in_sand_trap = true

func _on_exited_sand_trap():
	in_sand_trap = false