@tool
extends CharacterControllerState

var _required_exports : Array[String] = ["input_map", "variables", "animated_sprite"]
var _animation_exports : Array[String] = ["idle_animation", "walk_animation", "run_animation"]

@export var input_map: InputMapNode:
	set(val):
		input_map = val
		update_configuration_warnings()
@export var variables: MovementVariables:
	set(val):
		variables = val
		update_configuration_warnings()


@export_group("State Transitions")
## If set: character will change to this state if you input the opposite direction
## while running
@export var turnaround_state: CharacterControllerState:
	set(val):
		turnaround_state = val
		update_configuration_warnings()


@export_group("Animations")
@export var animated_sprite : AnimatedSprite2D:
	set(val):
		animated_sprite = val
		update_configuration_warnings()
@export var idle_animation := "idle":
	set(val):
		idle_animation = val
		update_configuration_warnings()
@export var walk_animation := "walk":
	set(val):
		walk_animation = val
		update_configuration_warnings()
@export var run_animation := "run":
	set(val):
		run_animation = val
		update_configuration_warnings()


@export_group("Animation Movement Magic")
## adjust this value until animation and movement speeds match
## You can use walk speed to make it easier to determine how accurate your current ratio is
@export var walk_speed_animation_magic_number := 1.0  
## adjust this value until animation and movement speeds match
## You can use run speed to make it easier to determine how accurate your current ratio is
@export var run_speed_animation_magic_number := 1.0

# Helper properties
var walk_accel: float:  ## Walk acceleration in pixels per second per second
	get:
		return variables.walk_speed / variables.time_to_walk
	set(val):
		push_error("Tried to set character acceleration through read only property walk_accel")

var run_accel: float:  ## Run acceleration in pixels per second per second
	get:
		return variables.run_speed / variables.time_to_run
	set(val):
		push_error("Tried to set character acceleration through read only property walk_accel")


func get_jump_accel_modifier() -> float:
	return actor.velocity.x * variables.jump_x_modifier


func get_x_velocity() -> float:
	return actor.velocity.x

func enter(_from: StringName, data: Dictionary[String, Variant]) -> void:
	if "velocity" in data and data["velocity"] is Vector2:
		actor.velocity = data["velocity"]
	actor.velocity.y = 0
	actor.velocity.x = min(actor.velocity.x, variables.run_speed)

func physics_tick(delta: float) -> void:
	var block_actor_turnaround := false  # If true, skip turning actor around on reverse input
	# Signed digital movement: -1;0;1
	var walk_input: int = int(Input.is_action_pressed(input_map.walk_right_input)) - int(Input.is_action_pressed(input_map.walk_left_input))
	
	# Turnaround
	var real_velocity: Vector2 = actor.get_real_velocity()
	var h_speed: float = abs(real_velocity.x)
	if turnaround_state != null and walk_input != 0 and h_speed > variables.walk_speed:
		var direction := int(signf(real_velocity.x))
		if direction * -1 == walk_input:
			var reverse_velocity := Vector2(real_velocity.x * -1, real_velocity.y)
			state_machine.request_state_change(turnaround_state.name, {"velocity": reverse_velocity})
			block_actor_turnaround = true
	
	# Idle and walk logic:
	var is_running: bool = Input.is_action_pressed(input_map.run_input)
	var desired_h_velocity: float = (variables.run_speed if Input.is_action_pressed(input_map.run_input) else variables.walk_speed) * walk_input
	var accel: float = (run_accel if is_running else walk_accel) * delta
	actor.velocity.x = move_toward(actor.velocity.x, desired_h_velocity, accel)
	
	# Looking left and right
	if not block_actor_turnaround and walk_input != 0:
		actor.looking_left = walk_input == -1
	
	# Animation handling
	if actor.get_real_velocity().x == 0:
		animated_sprite.play(idle_animation)
	elif is_running:
		var run_speed_animation_ratio: float = abs(actor.velocity.x) / run_speed_animation_magic_number
		animated_sprite.play(run_animation, run_speed_animation_ratio)
	else:
		var walk_speed_animation_ratio: float = abs(actor.velocity.x) / walk_speed_animation_magic_number
		animated_sprite.play(walk_animation, walk_speed_animation_ratio)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	warnings += ConfigurationWarningHelper.collect_required_warnings(self, _required_exports)
	warnings += ConfigurationWarningHelper.collect_animation_warnings(self, _animation_exports, animated_sprite.sprite_frames.get_animation_names())
	return warnings
