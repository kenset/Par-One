extends RigidBody2D

export var POWER_MULTIPLIER = 5
export var WALL_POINTS = 10

signal golf_ball_hit
signal score_points

func _ready():
	self.set_process_input(true)
	self.connect("body_entered", self, "_on_body_entered")

func _process(delta):
	$Arrow.look_at(get_global_mouse_position())

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE:
			_hit_golf_ball()

func _hit_golf_ball():
	emit_signal("golf_ball_hit")

func _on_power_level_selected(power_level):
	self.apply_central_impulse((get_global_mouse_position() - self.position).normalized() * (power_level * POWER_MULTIPLIER))

func _on_body_entered(body):
	emit_signal("score_points", WALL_POINTS)

func _on_hole_in_one():
	queue_free()