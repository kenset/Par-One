extends Node2D

export var STARTING_TIME = 5

func _ready():
	$Label.text = String(STARTING_TIME)
#	$Timer.start(STARTING_TIME)

func _process(delta):
	$Label.text = String(ceil($Timer.time_left))
