extends Node2D

signal score_points
signal hole_in_one

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")

#func _process(delta):
#	pass

func _on_body_entered(body):
	hole_in_one()
	emit_signal("score_points", 1000)

func hole_in_one():
	$Audio.play(0.0)
	emit_signal("hole_in_one")