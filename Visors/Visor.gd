extends CharacterBody2D
class_name Visor

enum {
	Move,
	Cast,
	GetHit,
}

var state

func _ready():
	state = Move
