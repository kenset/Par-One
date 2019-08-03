extends RigidBody2D

export var POWER_MULTIPLIER = 5

signal golf_ball_hit

func _ready():
	self.set_process_input(true)

func _process(delta):
	$Arrow.look_at(get_global_mouse_position())

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_A:
			_hit_golf_ball()

func _hit_golf_ball():
	emit_signal("golf_ball_hit")
	
func _on_power_level_selected(power_level):
	self.apply_central_impulse((get_global_mouse_position() - self.position).normalized() * (power_level * POWER_MULTIPLIER))