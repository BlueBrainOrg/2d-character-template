extends Node2D
class_name LedgeDetector

@onready var exclusion: Area2D = $Exclusion
@onready var ray_cast_down: RayCast2D = %RayCastDown
@onready var ray_cast_side: RayCast2D = %RayCastSide

func _ready() -> void:
	ray_cast_down.add_exception(get_parent())
	ray_cast_side.add_exception(get_parent())

func has_snap_point() -> bool:
	var v_colliding := ray_cast_down.is_colliding()
	var h_colliding := ray_cast_side.is_colliding()
	var exclusion_overlap: bool = exclusion.get_overlapping_bodies().size() > 0
	print(v_colliding and h_colliding and not exclusion_overlap)
	return v_colliding and h_colliding and not exclusion_overlap


func get_snap_point() -> Vector2:
	assert(has_snap_point(), "No snap point available, be sure to call has_snap_point before calling get_snap_point")
	var v_cast_point: Vector2 = ray_cast_down.get_collision_point()
	var h_cast_point: Vector2 = ray_cast_side.get_collision_point()
	var output := Vector2(h_cast_point.x, v_cast_point.y)
	return output
