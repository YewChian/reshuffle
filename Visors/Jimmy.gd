extends Visor


func initialize_stats():
	id = "Jimmy"
	max_hp = 100
	hp = 100
	max_nap_points = 100
	

func _physics_process(delta):
	super(delta)
	handle_input()
	

func handle_input():
	match state:
		Move:
			move_direction = get_tree().current_scene.get_node("CanvasLayer/Joystick").direction
			if move_direction != Vector2(0,0):
				last_direction = move_direction
				
			if move_direction.y < 0:
				if abs(move_direction.y) > abs(move_direction.x):
					$AnimationPlayer.play("move_up")
				elif move_direction.x < 0:
					$AnimationPlayer.play("move_left")
				elif move_direction.x > 0:
					$AnimationPlayer.play("move_right")

			else:
				if abs(move_direction.y) > abs(move_direction.x):
					$AnimationPlayer.play("move_down")
				elif move_direction.x < 0:
					$AnimationPlayer.play("move_left")
				elif move_direction.x > 0:
					$AnimationPlayer.play("move_right")

			move_and_collide(move_direction.normalized())
			
			
func increment_nap_points():
	super()
	get_tree().current_scene.get_node("CanvasLayer/DeckMContainer/NapDisplay/NapProgress").scale.y = float(nap_points)/float(max_nap_points)


func reshuffle():
	get_tree().current_scene.get_node("CanvasLayer/DeckMContainer/NapDisplay").visible = false
	super()
	get_tree().current_scene.get_node("CanvasLayer/DeckMContainer/NapDisplay/NapProgress").scale.y = 0
	

func initialize_deck():
	deck.append("bark")
	deck.append("bark")
	deck.append("bark")
	await reveal_top_card("Jimmy")
