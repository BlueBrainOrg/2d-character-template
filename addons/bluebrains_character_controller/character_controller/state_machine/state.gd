@tool
@icon("res://addons/bluebrains_character_controller/icons/diamond-yellow.png")
extends Node
class_name CharacterControllerState

var state_machine: CharacterControllerStateMachine
var actor: CharacterBody2D

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
