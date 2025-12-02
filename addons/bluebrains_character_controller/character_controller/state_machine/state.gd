@tool
@icon("res://addons/bluebrains_character_controller/icons/diamond-yellow.png")
extends Node
class_name CharacterControllerState

signal entered
signal entered_from(from:StringName)
signal exited
signal exited_to(to:StringName)

@export var is_available: bool = true

var state_machine: CharacterControllerStateMachine
var actor: Node2D

var is_active := false
var allow_state_change := true

func enter(_from: StringName, _data: Dictionary[String, Variant]) -> void:
	pass


func exit(_to: StringName, _data: Dictionary[String, Variant]) -> void:
	pass


func render_tick(_delta: float) -> void:
	pass


func physics_tick(_delta: float) -> void:
	pass
