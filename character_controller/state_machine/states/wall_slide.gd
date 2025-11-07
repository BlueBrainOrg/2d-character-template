@tool
extends CharacterControllerState

@export var input_map: InputMapNode:
	set(val):
		input_map = val
		update_configuration_warnings()
@export var variables: MovementVariables:
	set(val):
		variables = val
		update_configuration_warnings()

@export_group("Animations")
@export var animated_sprite: AnimatedSprite2D
@export var animation_name: String = "wall_slide"
@export var animation_speed_multiplier := 1.0

func enter(_from: StringName, _data: Dictionary[String, Variant]) -> void:
	actor.velocity = Vector2.ZERO
	#actor.looking_left = not actor.looking_left
	animated_sprite.play(animation_name, animation_speed_multiplier)


func physics_tick(_delta: float) -> void:
	var gravity: float = variables.wall_slide_speed / variables.time_to_wall_slide_speed
	actor.velocity.y = move_toward(actor.velocity.y, variables.wall_slide_speed, gravity)
