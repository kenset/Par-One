extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var SPEED = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_process_input(true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Arrow.look_at(get_global_mouse_position())

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_A:
			_hit_golf_ball()

func _hit_golf_ball():
	self.apply_central_impulse((get_global_mouse_position() - self.position).normalized() * SPEED)