extends Node2D

var parent
var state
var target_player
var post_cast_lag = 0.2

func _ready():
	parent = get_parent()
	enter_state("Idle")


func enter_state(new_state):
	state = new_state
	match state:
		"Idle":
			pass
			
		"Move":
			parent.move_direction = (target_player.global_position - global_position).normalized()
			
			if parent.move_direction != Vector2(0,0):
				parent.last_direction = parent.move_direction
				
			if parent.move_direction.y < 0:
				if abs(parent.move_direction.y) > abs(parent.move_direction.x):
					parent.get_node("AnimationPlayer").play("move_up")
				elif parent.move_direction.x < 0:
					parent.get_node("AnimationPlayer").play("move_left")
				elif parent.move_direction.x > 0:
					parent.get_node("AnimationPlayer").play("move_right")

			else:
				if abs(parent.move_direction.y) > abs(parent.move_direction.x):
					parent.get_node("AnimationPlayer").play("move_down")
				elif parent.move_direction.x < 0:
					parent.get_node("AnimationPlayer").play("move_left")
				elif parent.move_direction.x > 0:
					parent.get_node("AnimationPlayer").play("move_right")
			$StateTimer.start(0.1)
			
		"Cast":
			if parent.cast_button_state == "Nap":
				enter_state("Nap")
				return
				
			$StateTimer.stop()
			parent.move_direction = Vector2(0,0)
			parent.cast_top_card("not_Jimmy")
			
			randomize()
			var random_meter_check_time = randf_range(0.0, 1.0)
			await get_tree().create_timer(random_meter_check_time).timeout
			print("stopping meter after seconds: ", random_meter_check_time)
			parent.instanced_top_card.check_meter.stop_marker()
			
			await get_tree().create_timer(post_cast_lag).timeout
			enter_state("Move")
			$StartCastRadius/CollisionShape2D.disabled = true
			$StartCastRadius/CollisionShape2D.disabled = false
			
		"Nap":
			parent.is_incrementing_nap_points = true
			
		"Post Nap":
			pass
			
			
func _physics_process(delta):
	match state:
		"Move":
			parent.move_and_collide(parent.move_direction * parent.move_speed)
			
		"Nap":
			if parent.cast_button_state == "Post Nap":
				enter_state("Post Nap")
			else:
				parent.get_node("OverheadNapDisplay/OverheadNapProgress").scale.y = float(parent.nap_points)/float(parent.max_nap_points)

		"Post Nap":
			if parent.cast_button_state == "Reveal":
				# reset the detector to start detecting already overlapping collisions
				enter_state("Move")
				$StartCastRadius/CollisionShape2D.disabled = true
				await get_tree().create_timer(0.1).timeout
				$StartCastRadius/CollisionShape2D.disabled = false



func _on_start_move_radius_body_entered(body):
	if body.is_in_group("Jimmy"):
		if state == "Idle":
			target_player = body
			enter_state("Move")


func _on_start_cast_radius_body_entered(body):
	enter_state("Cast")


func _on_state_timer_timeout():
	enter_state(state)


