extends CharacterControllerState

@export_group("State Transitions")
@export var airborne_state: CharacterControllerState

@export_group("Jump")
@export var jump_force := 200.0

func enter(_from, _data):
	actor.velocity.y -= jump_force
	await get_tree().physics_frame
	state_machine.request_state_change(airborne_state.name, {})
  
