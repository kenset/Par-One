extends Node2D

func _ready():
	$AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")
	$AnimatedSprite.play()

func _on_animation_finished():
	self.queue_free()