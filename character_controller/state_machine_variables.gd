extends Node
class_name BehaviourVariables

@export var num_airdashes: int = 1
var airdash_counter: int = 0

func can_airdash() -> bool:
	return airdash_counter < num_airdashes

func _on_state_machine_state_changed(from: StringName, to: StringName) -> void:
	match [from, to]:
		["Airborne", "Dash"]:
			airdash_counter += 1
		["JumpAir", "Dash"]:
			airdash_counter += 1
		[_, "Grounded"]:
			airdash_counter = 0
		[_, "WallSlide"]:
			airdash_counter = 0
		[_, "Hang"]:
			airdash_counter = 0
