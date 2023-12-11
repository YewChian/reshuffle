extends CharacterBody2D
class_name Visor

var move_direction
var last_direction
var deck = []

enum {
	Move,
	Cast,
	GetHit,
}

var state

func _ready():
	state = Move
	initialize_deck()


func initialize_deck():
	pass
	
	
#cast function: casts card at top of deck
func cast_top_card():
	var top_card = deck.pop_front()
	var new_card = load(CardData.card_dict[top_card]).instantiate()
	add_child(new_card)
	new_card.cast()
