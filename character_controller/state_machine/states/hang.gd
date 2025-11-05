extends CharacterControllerState

@export var input_map: InputMapNode

@export_group("Animation")
@export var animated_sprite: AnimatedSprite2D
@export var animation_name: String

func enter(_from, data):
	var ledge_point = data["snap_point"]
	# Hanging frame
	animated_sprite.stop()
	animated_sprite.animation = animation_name
	animated_sprite.frame = 1
	
	# Player positioning and velocity
	actor.velocity = Vector2.ZERO
	var actor_corner = actor.global_position - actor.character_size / 2
	var displacement = ledge_point - actor_corner
	var margin = sign(displacement.x) * Vector2(0.1, 0)  # without this the player can float for some reason...
	actor.global_position += displacement + margin
