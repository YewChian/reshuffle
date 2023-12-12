extends CharacterBody2D
class_name Visor

var move_direction
var last_direction
var deck = []
var top_card_display
var played_card_display

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
func cast_top_card(visor_type):
	var top_card = deck.pop_front()
	var new_card = load(CardData.card_dict[top_card]["scene"]).instantiate()
	add_child(new_card)
	new_card.cast()
	
	top_card_display.get_node("AnimationPlayer").play("cast")
	played_card_display = top_card_display
	reveal_top_card(visor_type)

func reveal_top_card(visor_type):
	match visor_type:
		"Jimmy":
			var top_card_name = CardData.card_dict[deck[0]]
			var new_card_display = load("res://UI/CardDisplay.tscn").instantiate()
			get_tree().current_scene.get_node("CanvasLayer/CardDisplays").add_child(new_card_display)
			new_card_display.texture = load(top_card_name["image"])
			new_card_display.get_node("AnimationPlayer").play("unflip")
			
			top_card_display = new_card_display
			
		"not_Jimmy":
			pass
