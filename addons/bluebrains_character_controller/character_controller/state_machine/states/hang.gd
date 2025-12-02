@tool
extends CharacterControllerState

var _required_exports: Array[String] = ["animated_sprite"]
var _animation_exports: Array[String] = ["animation_name"]

@export_group("Animation")
@export var animated_sprite: AnimatedSprite2D:
	set(val):
		animated_sprite = val
		update_configuration_warnings()
@export var animation_name: String:
	set(val):
		animation_name = val
		update_configuration_warnings()

var execution_time: String

func enter(_from: StringName, data: Dictionary[String, Variant]) -> void:
	var ledge_point: Vector2 = data["snap_point"]
	allow_state_change = false
	# Hanging frame
	animated_sprite.play(animation_name)
	
	# Player positioning and velocity
	actor.velocity = Vector2.ZERO
	var corner_sign: int = 1 if actor.looking_left else -1
	var signed_size := Vector2(actor.character_size.x * corner_sign, actor.character_size.y)
	var actor_corner: Vector2 = actor.global_position - signed_size / 2
	var displacement: Vector2 = ledge_point - actor_corner
	var margin: Vector2 = sign(displacement.x) * Vector2(0.1, 0)  # without this the player can float for some reason...

	var target_global_position: Vector2 = actor.global_position + displacement + margin
	var tween := create_tween()
	tween.tween_property(actor, "global_position", target_global_position, 0.05)
	
	execution_time = Time.get_datetime_string_from_system()
	var _execution_time: String = execution_time
	await tween.finished
	if is_active and execution_time == _execution_time:
		allow_state_change = true

func exit(_to: StringName, _data: Dictionary[String, Variant]) -> void:
	allow_state_change = true

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	warnings += ConfigurationWarningHelper.collect_required_warnings(self, _required_exports)
	warnings += ConfigurationWarningHelper.collect_animation_warnings(self, _animation_exports, animated_sprite.sprite_frames.get_animation_names())
	return warnings
