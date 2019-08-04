extends Node2D

export var LABEL = 1

var signs: Array = ["sign_0", "sign_1", "sign_2", "sign_3", "sign_4", "sign_5"]

func _ready():
	for signPost in signs:
		find_node(signPost).visible = false
	randomize()
	find_node(signs[randi() % 5]).visible = true
	$Label.text = String(LABEL)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
