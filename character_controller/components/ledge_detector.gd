extends Node2D
class_name LedgeDetector

signal ledge_detected

@onready var exclusion: Area2D = $Exclusion
@onready var ray_cast_down: RayCast2D = %RayCastDown
@onready var ray_cast_side: RayCast2D = %RayCastSide

var bodies_in_exclusion: Dictionary[PhysicsBody2D, bool] = {}

var overlapping_ledge := false


func get_snap_point():
	var v_cast_body = ray_cast_down.get_collider()
	var h_colliding = ray_cast_side.is_colliding()
	if v_cast_body == null or v_cast_body in bodies_in_exclusion or not h_colliding:
		return null
	var v_cast_point = ray_cast_down.get_collision_point()
	var h_cast_point = ray_cast_side.get_collision_point()
	var output = Vector2(h_cast_point.x, v_cast_point.y)
	return output


func _on_exclusion_body_entered(body: Node2D) -> void:
	bodies_in_exclusion[body as PhysicsBody2D] = true


func _on_exclusion_body_exited(body: Node2D) -> void:
	if body in bodies_in_exclusion:
		bodies_in_exclusion.erase(body)
