extends Node2D

var score = 0
var points_to_add = 0

func _ready():
	pass 

func _process(delta):
	var currentScore = int($Label.text)
	if (currentScore < score):
		$Label.text = String(currentScore + (score / max(1, currentScore) * 10))
	else:
		$Label.text = String(score)

func _on_score_points(points):
	score += points