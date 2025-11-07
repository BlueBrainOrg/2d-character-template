@tool
extends CharacterControllerState

var _required_exports: Array[String] = ["input_map", "variables", "landing_state", "airborne_state", "animated_sprite"]
var _animation_exports: Array[String] = ["animation_name"]

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
@export var airborne_state: CharacterControllerState:
	set(val):
		airborne_state = val
		update_configuration_warnings()


@export_group("Animations")
@export var animated_sprite: AnimatedSprite2D:
	set(val):
		animated_sprite = val
		update_configuration_warnings()
@export var animation_name := "air_up":
	set(val):
		animation_name = val
		update_configuration_warnings()


@export_group("Behaviour")
@export var override_x_velocity := false
@export var multiply_velocity_looking_left := false
@export var x_velocity := 0.0
@export_range(0.0, 1.0) var ignore_input_time := 0.0  ## ratio multiplied to jump_time
@export var turnaround_on_enter := false

var execution_time: String
var speed_override := 0.0
var ignore_input := false

# Helper properties
var accel: float:  ## Walk acceleration in pixels per second per second
	get:
		return speed_override / variables.time_to_air_speed
	set(val):
		push_error("Tried to set character acceleration through read only property accel")


func get_y_velocity() -> float:
	return -variables.jump_height / variables.jump_time

func enter(_from: StringName, data: Dictionary[String, Variant]) -> void:
	var data_speed_override: float = abs(data.get("speed_override", 0))
	var x_override: float = x_velocity if override_x_velocity else 0.0
	speed_override = max(data_speed_override, variables.air_speed, x_override)
	
	ignore_input = ignore_input_time > 0.0
	if ignore_input:
		get_tree().create_timer(ignore_input_time * variables.jump_time).timeout.connect(set.bind("ignore_input", false), CONNECT_ONE_SHOT)
	
	if turnaround_on_enter:
		actor.looking_left = not actor.looking_left
	
	if override_x_velocity:
		var direction_multiplier: int = -1 if multiply_velocity_looking_left and actor.looking_left else 1
		actor.velocity.x = x_velocity * direction_multiplier
	actor.velocity.y = get_y_velocity()
	animated_sprite.play(animation_name)
	
	execution_time = Time.get_datetime_string_from_system()
	var entered_at := execution_time
	await get_tree().create_timer(variables.jump_time).timeout
	if state_machine.current_state == name and execution_time == entered_at:
		actor.velocity.y /= 3
		state_machine.request_state_change(airborne_state.name, {"speed_override": speed_override})

func physics_tick(_delta: float) -> void:
	if actor.is_on_ceiling() or not Input.is_action_pressed(input_map.jump_input):
		actor.velocity.y /= 3
		state_machine.request_state_change(airborne_state.name, {"speed_override": speed_override})
		return
	
	if not ignore_input:
		var h_input: int = int(Input.is_action_pressed(input_map.walk_right_input)) - int(Input.is_action_pressed(input_map.walk_left_input))
		var desired_h_speed: float = speed_override * h_input
		actor.velocity.x = move_toward(actor.get_real_velocity().x, desired_h_speed, accel)
		if h_input != 0:
			actor.looking_left = h_input == -1
	
	# If you lose run speed you don't get it back
	speed_override = max(abs(actor.get_real_velocity().x), variables.air_speed)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	warnings += ConfigurationWarningHelper.collect_required_warnings(self, _required_exports)
	warnings += ConfigurationWarningHelper.collect_animation_warnings(self, _animation_exports, animated_sprite.sprite_frames.get_animation_names())
	return warnings
