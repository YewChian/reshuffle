extends Button

var state = "Reveal"

func _on_pressed():
	match state:
		"Reveal":
			print("4. cast top card")
			get_tree().current_scene.get_node("Jimmy").cast_top_card("Jimmy")
		
		"MeterCheck":
			get_tree().current_scene.get_node("Jimmy").instanced_top_card.check_meter.stop_marker()
			
		"Nap":
			pass
					
func _on_button_down():
	match state:
		"Nap":
			get_tree().current_scene.get_node("Jimmy").is_incrementing_nap_points = true


func _on_button_up():
	match state:
		"Nap":
			get_tree().current_scene.get_node("Jimmy").is_incrementing_nap_points = false
			

func _process(delta):
	state = get_tree().current_scene.get_node("Jimmy").cast_button_state



