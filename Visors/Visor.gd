extends CharacterBody2D
class_name Visor

var direction
var last_direction

enum {
	Move,
	Cast,
	GetHit,
}

var state

func _ready():
	state = Move
