extends Node2D

signal score_points
signal hole_in_one

export var IS_SPECIAL = false

func _ready():
	if (IS_SPECIAL):
		$NormalHole.hide()
		$SpecialHole.show()
	$Area2D.connect("body_entered", self, "_on_body_entered")

#func _process(delta):
#	pass

func _on_body_entered(body):
	hole_in_one()
	emit_signal("score_points", 1000)

func hole_in_one():
	if (IS_SPECIAL):
		$SpecialHoleAudio.play()
	else:
		$NormalHoleAudio.play()
	emit_signal("hole_in_one", IS_SPECIAL)