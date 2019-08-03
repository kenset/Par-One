extends Node2D

var score = 0

func _ready():
	pass 

func _process(delta):
	pass

func _on_score_points(points):
	score += points
	$Label.text = String(score)