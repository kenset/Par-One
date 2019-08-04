extends Node2D

signal entered_sand_trap
signal exited_sand_trap

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")
	$Area2D.connect("body_exited", self, "_on_body_exited")

#func _process(delta):
#	pass

func _on_body_entered(body):
	get_tree().call_group("golfBall", "_on_entered_sand_trap")

func _on_body_exited(body):
	get_tree().call_group("golfBall", "_on_exited_sand_trap")