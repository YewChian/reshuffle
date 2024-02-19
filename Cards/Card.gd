extends Node
class_name Card

var id
var damage
var check_meter


func _ready():
	initialize_stats()
	initialize_collision()
	check_meter = $CheckMeterParent.get_children()[0]
	check_meter.marker_stopped.connect(finish_cast)
	

func initialize_stats():
	pass


func initialize_collision():
	if get_parent().is_in_group("Jimmy"):
		$Hitbox.set_collision_layer_value(2, true)
		$Hitbox.set_collision_layer_value(5, true)
	else:
		$Hitbox.set_collision_layer_value(3, true)
		$Hitbox.set_collision_layer_value(4, true)


func cast_check():
	check_meter.move_marker()
	# when cast button is clicked again, get the position of the cast marker and calculate bonus damage / effects
	

func cast():
	cast_check()
	

func finish_cast(cast_quality):
	var cast_button_reference = get_tree().current_scene.get_node("CanvasLayer/CastButton")
	
	if len(get_parent().deck) == 0:
		get_parent().start_nap()
		
	else:
		get_parent().cast_button_state = "Reveal"
	
	match cast_quality:
		"Red":
			damage *= 0.5
			$CardQualityLabel.text = "HORRID"
		"Yellow":
			damage *= 1
			$CardQualityLabel.text = "ACCEPTABLE"
		"Green":
			damage *= 2
			$CardQualityLabel.text = "EXCELLENT"
	
	get_parent().finish_cast_animation(id)
	
	#$Hitbox.rotation = get_parent().last_direction.angle() + PI/2
	$AnimationPlayer.play("finish_cast")
	await $AnimationPlayer.animation_finished
	
	queue_free()
