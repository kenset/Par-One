extends Node2D

signal score_points

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")

#func _process(delta):
#	pass

func _on_body_entered(body):
	hole_in_one()
	emit_signal("score_points", 1000)

func hole_in_one():
	print("hole in one!")