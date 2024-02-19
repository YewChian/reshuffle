extends Control

var is_pressing
var deadzone = 5
var ring_radius = 24
var direction = Vector2(0,0)
var last_direction = Vector2(0,0)


func _on_joystick_button_button_down():
	is_pressing = true


func _on_joystick_button_button_up():
	is_pressing = false


func _process(delta):
	if is_pressing:
		if get_global_mouse_position().distance_to($Center.global_position) <= ring_radius:
			$Joyknob.global_position = get_global_mouse_position()
			
		else:
			var angle = $Center.global_position.angle_to_point(get_global_mouse_position())
			$Joyknob.global_position.x = $Center.global_position.x + cos(angle)*ring_radius
			$Joyknob.global_position.y = $Center.global_position.y + sin(angle)*ring_radius
			
		calculate_direction()
		
	else:
		$Joyknob.global_position = lerp($Joyknob.global_position, $Center.global_position, delta*50)
		direction = Vector2(0,0)
	
		
func calculate_direction():
	if abs(($Joyknob.global_position.x - $Center.global_position.x)) >= deadzone:
		direction.x = ($Joyknob.global_position.x - $Center.global_position.x) / ring_radius
	if abs(($Joyknob.global_position.y - $Center.global_position.y)) >= deadzone:
		direction.y = ($Joyknob.global_position.y - $Center.global_position.y) / ring_radius
	last_direction = direction
