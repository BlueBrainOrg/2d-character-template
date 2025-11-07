@tool
@icon("res://addons/plenticons/icons/16x/custom/diamond-jump-to-yellow.png")
extends CharacterControllerState
class_name OneShotState
## Use this state for when you need to play an animation and change to a different state
## at the end of the animation or after a timer runs out.

var _required_exports: Array[String] = ["to_state", "animated_sprite"]
var _animation_exports: Array[String] = ["animation_name"]

@export var to_state: CharacterControllerState:
	set(val):
		to_state = val
		update_configuration_warnings()


@export_group("Animation")
@export var animated_sprite: AnimatedSprite2D:
	set(val):
		animated_sprite = val
		update_configuration_warnings()
@export var animation_name: String:
	set(val):
		animation_name = val
		update_configuration_warnings()
@export var time_shortcut: bool = false
@export var time: float = 0.0

@export_group("Behaviour")
@export var turnaround_on_enter := false
@export var override_x_movement := false
@export var multiply_x_by_looking_left := false
@export var x_movement_value := 0.0
@export var x_movement_delta := 5.0
@export var override_y_movement := false
@export var y_movement_value := 0.0
@export var y_movement_delta := 5.0

@export_group("Data")
@export var _data: Dictionary = {}
@export var dynamic_data: Dictionary[String, DynamicDataRow] = {}

func enter(_from: StringName, data: Dictionary[String, Variant]) -> void:
	animated_sprite.play(animation_name)
	if turnaround_on_enter:
		actor.looking_left = not actor.looking_left
	if animated_sprite.sprite_frames.get_animation_loop(animation_name) or time_shortcut:
		print("waiting for time_shortcut")
		await get_tree().create_timer(time).timeout
	else:
		await animated_sprite.animation_finished
	state_machine.request_state_change(to_state.name, get_all_data(data))

func physics_tick(_delta: float) -> void:
	if override_x_movement:
		var direction_modifier: int = -1 if multiply_x_by_looking_left and actor.looking_left else 1
		actor.velocity.x = move_toward(actor.velocity.x, x_movement_value * direction_modifier, x_movement_delta)
	
	if override_y_movement:
		actor.velocity.y = move_toward(actor.velocity.y, y_movement_value, y_movement_delta)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	warnings += ConfigurationWarningHelper.collect_required_warnings(self, _required_exports)
	warnings += ConfigurationWarningHelper.collect_animation_warnings(self, _animation_exports, animated_sprite.sprite_frames.get_animation_names())
	return warnings

func get_all_data(data: Dictionary[String, Variant]) -> Dictionary[String, Variant]:
	var result: Dictionary[String, Variant] = data.duplicate()
	result.merge(_data)
	for key in dynamic_data:
		var row: DynamicDataRow = dynamic_data[key]
		var row_object: Node = get_node(row.object)
		var value: Variant = row_object.get(row.property)
		if value is Callable:
			value = value.call()
		result[key] = value
	return result
