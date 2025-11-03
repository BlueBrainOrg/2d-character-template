extends CharacterControllerState
class_name GroundedPlayerState

@export var input_map: InputMapNode
@export var variables: MovementVariables

@export_group("State Transitions")
@export var jump_state: CharacterControllerState
@export var fall_state: CharacterControllerState

@export_group("Animations")
@export var animated_sprite : AnimatedSprite2D
@export var idle_animation := "idle"
@export var walk_animation := "walk"
@export var run_animation := "run"

@export_group("Animation Movement Magic")
## adjust this value until animation and movement speeds match
## You can use walk speed to make it easier to determine how accurate your current ratio is
@export var walk_speed_animation_magic_number = 1.0  
## adjust this value until animation and movement speeds match
## You can use run speed to make it easier to determine how accurate your current ratio is
@export var run_speed_animation_magic_number = 1.0

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


func enter(_from, _data):
	actor.velocity.y = 0


func physics_tick(delta):
	if not actor.is_on_floor():
		state_machine.request_state_change(fall_state.name)
		return
	if Input.is_action_just_pressed(input_map.jump_input) and jump_state != null:
		state_machine.request_state_change(jump_state.name, {"speed_override": actor.velocity.x * variables.jump_x_modifier})
	
	# Idle and walk logic:
	# Binary movement: -1;0;1
	var walk_input = Input.get_action_strength(input_map.walk_right_input) - Input.get_action_strength(input_map.walk_left_input)
	var is_running = Input.is_action_pressed(input_map.run_input)
	if walk_input != 0:
		walk_input = walk_input / abs(walk_input)
	var desired_h_velocity = (variables.run_speed if Input.is_action_pressed(input_map.run_input) else variables.walk_speed) * walk_input
	var accel = (run_accel if is_running else walk_accel) * delta
	actor.velocity.x = move_toward(actor.velocity.x, desired_h_velocity, accel)
	# Looking left and right
	if walk_input != 0:
		actor.looking_left = walk_input == -1
	
	# Animation handling
	if actor.get_real_velocity().x == 0:
		animated_sprite.play(idle_animation)
	elif is_running:
		var run_speed_animation_ratio = abs(actor.velocity.x) / run_speed_animation_magic_number
		animated_sprite.play(run_animation, run_speed_animation_ratio)
	else:
		var walk_speed_animation_ratio = abs(actor.velocity.x) / walk_speed_animation_magic_number
		animated_sprite.play(walk_animation, walk_speed_animation_ratio)
