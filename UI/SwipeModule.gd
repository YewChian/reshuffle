extends Area2D


func _physics_process(delta):
	if Input.is_action_just_pressed("pressed"):
		print("press detected")
