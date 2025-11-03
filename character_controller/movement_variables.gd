extends Node
class_name MovementVariables

@export_group("Grounded")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var walk_speed: float = 100.0  ## Speed in pixels per second
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var time_to_walk: float = 0.05  ## Time it takes to reach walk_speed from 0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var run_speed: float = 200.0  ## Speed in pixels per second
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var time_to_run: float = 0.1  ## Time it takes to reach run_speed from 0

@export_group("Airborne")
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var air_speed: float = 100.0  ## Speed in pixels per second
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var time_to_air_speed: float = 0.05  ## Time it takes to reach air_speed from 0
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var fall_speed: float = 200.0  ## Speed in pixels per second
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var time_to_fall_speed: float = 0.05  ## Time it takes to reach fall_speed from 0

@export_group("Jump")
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var jump_height: float = 50.0
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var jump_time: float = .25
@export var jump_x_modifier: float = 1.25
