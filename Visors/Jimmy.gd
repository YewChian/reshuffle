extends Visor

func _physics_process(delta):
	print(state)
	handle_input()
	

func handle_input():
	match state:
		Move:
			print("moving")
			move_direction = get_tree().current_scene.get_node("CanvasLayer/Joystick").direction
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
			

func initialize_deck():
	deck.append("bark")
	deck.append("bark")
	deck.append("bark")
	reveal_top_card("Jimmy")
