extends Visor


func initialize_stats():
	id = "SleepySpaniel"
	max_hp = 100
	hp = 100
	max_nap_points = 100
	move_speed = 0.2
	for child_node in get_children():
		if child_node.is_in_group("Nature"):
			nature = child_node


func initialize_deck():
	deck.append("bark")
	deck.append("bark")
	deck.append("bark")
	await reveal_top_card("not_Jimmy")
	

func _ready():
	super()
