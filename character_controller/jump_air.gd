extends CharacterControllerState

@export var input_map: InputMapNode
@export var variables: MovementVariables

@export_group("State Transitions")
@export var landing_state: CharacterControllerState
@export var airborne_state: CharacterControllerState


@export_group("Animations")
@export var animated_sprite: AnimatedSprite2D
@export var animation_name := "air_up"


var execution_hash
var speed_override := 0.0

# Helper properties
var accel: float:  ## Walk acceleration in pixels per second per second
	get:
		return speed_override / variables.time_to_air_speed
	set(val):
		push_error("Tried to set character acceleration through read only property walk_accel")


func get_y_velocity():
	return -variables.jump_height / variables.jump_time

func enter(_from, data):
	var data_speed_override = abs(data.get("speed_override", 0))
	speed_override = max(data_speed_override, variables.air_speed)

	execution_hash = Time.get_datetime_string_from_system()
	var entered_at = execution_hash
	
	actor.velocity.y = get_y_velocity()
	animated_sprite.play(animation_name)
	await get_tree().create_timer(variables.jump_time).timeout
	if state_machine.current_state == name and execution_hash == entered_at:
		actor.velocity.y /= 3
		state_machine.request_state_change(airborne_state.name, {"speed_override": speed_override})

func physics_tick(_delta):
	if actor.is_on_ceiling() or not Input.is_action_pressed(input_map.jump_input):
		actor.velocity.y /= 3
		state_machine.request_state_change(airborne_state.name, {"speed_override": speed_override})
		return
	
	var h_input = int(Input.is_action_pressed(input_map.walk_right_input)) - int(Input.is_action_pressed(input_map.walk_left_input))
	var desired_h_speed = speed_override * h_input
	actor.velocity.x = move_toward(actor.velocity.x, desired_h_speed, accel)
	
	# If you lose run speed you don't get it back
	speed_override = max(abs(actor.velocity.x), variables.air_speed)
	
	# Looking left and right
	if h_input != 0:
		actor.looking_left = h_input == -1
