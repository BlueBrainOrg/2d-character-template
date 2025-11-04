@tool
extends CharacterControllerState
class_name AirborneState

var _required_exports = [
	"input_map", "variables", "landing_state", "animated_sprite", "rise_animation", 
	"neutral_animation", "fall_animation"
]
var _animation_exports = ["rise_animation", "neutral_animation", "fall_animation"]

@export var input_map: InputMapNode:
	set(val):
		input_map = val
		update_configuration_warnings()
@export var variables: MovementVariables:
	set(val):
		variables = val
		update_configuration_warnings()


@export_group("State Transitions")
@export var landing_state: CharacterControllerState:
	set(val):
		landing_state = val
		update_configuration_warnings()


@export_group("Animations")
@export var animated_sprite: AnimatedSprite2D:
	set(val):
		animated_sprite = val
		update_configuration_warnings()

@export var rise_animation := "air_up":
	set(val):
		rise_animation = val
		update_configuration_warnings()

@export var neutral_animation := "air_neutral":
	set(val):
		neutral_animation = val
		update_configuration_warnings()

@export var fall_animation := "air_down":
	set(val):
		fall_animation = val
		update_configuration_warnings()

@export var neutral_margin := 5.0:
	set(val):
		neutral_margin = val
		update_configuration_warnings()


var speed_override := 0.0

# Helper properties
var accel: float:  ## Walk acceleration in pixels per second per second
	get:
		return speed_override / variables.time_to_air_speed
	set(val):
		push_error("Tried to set character acceleration through read only property walk_accel")


func enter(_from, data):
	var data_speed_override = abs(data.get("speed_override", 0))
	speed_override = max(data_speed_override, variables.air_speed)


func physics_tick(delta):
	if actor.is_on_floor():
		state_machine.request_state_change(landing_state.name)
		return
	var gravity = variables.fall_speed / variables.time_to_fall_speed
	actor.velocity.y = move_toward(actor.velocity.y, variables.fall_speed, gravity * delta)
	
	var h_input = int(Input.is_action_pressed(input_map.walk_right_input)) - int(Input.is_action_pressed(input_map.walk_left_input))
	var desired_h_speed = speed_override * h_input
	actor.velocity.x = move_toward(actor.velocity.x, desired_h_speed, accel)
	
	# If you lose run speed you don't get it back
	speed_override = max(abs(actor.velocity.x), variables.air_speed)
	
	# Looking left and right
	if h_input != 0:
		actor.looking_left = h_input == -1
	
	# Animation
	if abs(actor.velocity.y) <= neutral_margin:
		animated_sprite.play(neutral_animation)
	elif actor.velocity.y > neutral_margin:
		animated_sprite.play(fall_animation)
	else:
		animated_sprite.play(rise_animation)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	warnings += ConfigurationWarningHelper.collect_required_warnings(self, _required_exports)
	warnings += ConfigurationWarningHelper.collect_animation_warnings(self, _animation_exports, animated_sprite.sprite_frames.get_animation_names())
	return warnings
