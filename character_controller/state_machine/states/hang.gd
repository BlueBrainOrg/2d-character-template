extends CharacterControllerState

@export var input_map: InputMapNode

@export_group("Animation")
@export var animated_sprite: AnimatedSprite2D
@export var animation_name: String

var execution_time

func enter(_from, data):
	var ledge_point = data["snap_point"]
	allow_state_change = false
	# Hanging frame
	animated_sprite.stop()
	animated_sprite.animation = animation_name
	animated_sprite.frame = 1
	
	# Player positioning and velocity
	actor.velocity = Vector2.ZERO
	var corner_sign = 1 if actor.looking_left else 1
	var signed_size = Vector2(actor.character_size.x * corner_sign, actor.character_size.y)
	var actor_corner = actor.global_position - signed_size / 2
	var displacement = ledge_point - actor_corner
	var margin = sign(displacement.x) * Vector2(0.1, 0)  # without this the player can float for some reason...

	var target_global_position = actor.global_position + displacement + margin
	var tween = create_tween()
	tween.tween_property(actor, "global_position", target_global_position, 0.1)
	execution_time = Time.get_datetime_string_from_system()
	
	var _execution_time = execution_time
	await tween.finished
	if is_active and execution_time == _execution_time:
		allow_state_change = true

func exit(_to, _data):
	allow_state_change = true
