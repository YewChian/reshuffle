extends Visor


func _physics_process(delta):
	print(state)
	handle_input()
	

func handle_input():
	match state:
		Move:
			print("moving")
			direction = get_tree().current_scene.get_node("CanvasLayer/Joystick").direction
			move_and_collide(direction.normalized())
			

