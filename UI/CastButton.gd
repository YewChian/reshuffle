extends Button

func _on_pressed():
	get_tree().current_scene.get_node("Jimmy").cast_top_card()
