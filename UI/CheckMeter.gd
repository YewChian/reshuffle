extends Node2D

var cast_quality = "Huh"
var marker_move_tween

signal marker_stopped(cast_quality)
	
	
func move_marker():
	$Marker.global_position = $MarkerStartPosition.global_position
	marker_move_tween = get_tree().create_tween()
	marker_move_tween.tween_property($Marker, "global_position", $MarkerEndPosition.global_position, 1)
	

func stop_marker():
	marker_move_tween.kill()
	emit_signal("marker_stopped", cast_quality)
	

func _on_marker_area_entered(area):
	if area.is_in_group("MeterArea") == false:
		print("MeterMarker is interacting with non-MeterArea area.")
	else:
		if area.is_in_group("EndArea"):
			emit_signal("marker_stopped", cast_quality)
			return
			
		if area.is_in_group("GreenArea"):
			cast_quality = "Green"
		elif area.is_in_group("YellowArea"):
			cast_quality = "Yellow"
		elif area.is_in_group("RedArea"):
			cast_quality = "Red"
