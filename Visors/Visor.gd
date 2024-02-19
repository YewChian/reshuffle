extends CharacterBody2D
class_name Visor

var move_direction
var last_direction = Vector2(0,0)
var deck = []
var top_card_display
var played_card_display_array = []
var instanced_top_card
var cast_button_state
var is_incrementing_nap_points = false

var id
var nap_points
var max_nap_points
var move_speed
var max_hp
var hp

var nature

var finish_cast_texture_dict = {
	"Jimmy":{
		"Bark":{
			"texture_path":"res://Assets/Cards/BarkJimmy.png",
			"hframes":6,
			"vframes":1,
			},
		},
	"SleepySpaniel":{
		"Bark":{
			"texture_path":"res://Assets/Cards/BarkSleepySpaniel.png",
			"hframes":6,
			"vframes":1,
			},
		},
}

enum {
	Move,
	Cast,
	GetHit,
}

var state

func _ready():
	state = Move
	cast_button_state = "Reveal"
	is_incrementing_nap_points = false
	initialize_stats()
	initialize_deck()
	initialize_hpBar()
	

func initialize_hpBar():
	if is_in_group("Jimmy"):
		update_Jimmy_hpBar()
	else:
		update_overhead_hpBar()


func initialize_stats():
	pass


func initialize_deck():
	pass
	
	
#cast function: casts card at top of deck
func cast_top_card(visor_type):
	cast_button_state = "MeterCheck"
	var top_card_name = deck.pop_front()
	instanced_top_card = load(CardData.card_dict[top_card_name]["scene"]).instantiate()
	add_child(instanced_top_card)
	
	if visor_type == "Jimmy":
		top_card_display.get_node("AnimationPlayer").play("cast")
	elif visor_type == "not_Jimmy":
		top_card_display.get_node("AnimationPlayer").play("overhead_cast")
		
	instanced_top_card.cast()
	
	played_card_display_array.append(top_card_display)
	reveal_top_card(visor_type)


func _physics_process(delta):
	if is_incrementing_nap_points:
		increment_nap_points()


func show_deck_ui_empty():
	get_tree().current_scene.get_node("CanvasLayer/DeckMContainer/Deck").visible = false


func reveal_top_card(visor_type):
	match visor_type:
		"Jimmy":
			if len(deck) == 0:
				await reveal_nap_card(visor_type)
			else:
				var top_card = CardData.card_dict[deck[0]]
				var new_card_display = load("res://UI/CardDisplay.tscn").instantiate()
				get_tree().current_scene.get_node("CanvasLayer/CardDisplays").add_child(new_card_display)
				new_card_display.texture = load(top_card["image"])
				new_card_display.get_node("AnimationPlayer").play("unflip")
				
				top_card_display = new_card_display
				
			
		"not_Jimmy":
			if len(deck) == 0:
				await reveal_nap_card(visor_type)
			else:
				var top_card = CardData.card_dict[deck[0]]
				var new_card_display = load("res://UI/CardDisplay.tscn").instantiate()
				$OverheadCardDisplay.add_child(new_card_display)
				new_card_display.texture = load(top_card["image"])
				new_card_display.get_node("AnimationPlayer").play("unflip")
				
				top_card_display = new_card_display
				

func finish_cast_animation(card_id):
	$Sprite2D.visible = false
	
	$CastedCardSprite.texture = load(finish_cast_texture_dict[id][card_id]["texture_path"])
	$CastedCardSprite.hframes = finish_cast_texture_dict[id][card_id]["hframes"]
	$CastedCardSprite.vframes = finish_cast_texture_dict[id][card_id]["vframes"]
	
	print($CastedCardSprite.hframes)
	var animation_name = str(id + card_id)
	$CastedCardSprite/FinishCastAnimationPlayer.play(animation_name)
	await $CastedCardSprite/FinishCastAnimationPlayer.animation_finished
	
	$Sprite2D.visible = true

func start_nap():
	nap_points = 0
	cast_button_state = "Nap"


func reveal_nap_card(visor_type):
	match visor_type:
		"Jimmy":
			get_tree().current_scene.get_node("CanvasLayer/DeckMContainer/NapDisplay").visible = true
			top_card_display = null
			
		"not_Jimmy":
			$OverheadNapDisplay.visible = true
			top_card_display = null


func increment_nap_points():
	if nap_points >= max_nap_points:
		is_incrementing_nap_points = false
		cast_button_state = "Post Nap"
		is_incrementing_nap_points = false
		nap_points = 0
		$OverheadNapDisplay.visible = false
		await reshuffle()
	nap_points += 1
	
	
func reshuffle():
	for played_card_display in played_card_display_array:
		print(played_card_display)
		played_card_display.get_node("AnimationPlayer").play("move_to_deck")
		await played_card_display.get_node("AnimationPlayer").animation_finished
	
	for played_card_display in played_card_display_array:
		played_card_display.queue_free()
		
	played_card_display_array = []
	
	await initialize_deck()
	cast_button_state = "Reveal"



func get_hit(area):
	var card_damage = area.get_parent().damage
	hp -= card_damage
	if is_in_group("Jimmy"):
		update_Jimmy_hpBar()
	else:
		update_overhead_hpBar()
		

func update_Jimmy_hpBar():
	get_tree().current_scene.get_node("CanvasLayer/hpBar").max_value = max_hp
	get_tree().current_scene.get_node("CanvasLayer/hpBar").value = hp
	
	
func update_overhead_hpBar():
	pass


func _on_hurtbox_area_entered(area):
	get_hit(area)
