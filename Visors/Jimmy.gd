extends Visor

func _physics_process(delta):
	handle_input()
	

func handle_input():
	match state
