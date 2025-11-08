extends CharacterBody2D
class_name PlayerCharacterBody2D

@onready var ledge_detector_r: LedgeDetector = %LedgeDetectorR
@onready var ledge_detector_l: LedgeDetector = %LedgeDetectorL
@onready var state_machine: CharacterControllerStateMachine = %StateMachine

@export var character_size: Vector2

@export_group("Jump")
@export_custom(PROPERTY_HINT_NONE, "suffix:px") var jump_height: float = 10.0  ## Pixels the character will rise in a full jump
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var jump_raise_time: float = 0.5  ## Time it takes to reach summit in jump
@export_custom(PROPERTY_HINT_NONE, "suffix:s") var jump_fall_time: float = 0.5  ## Time it takes to fall to floor from summit

@export_group("Control Variables")
@export var looking_left := false

func _physics_process(_delta: float) -> void:
	move_and_slide()
