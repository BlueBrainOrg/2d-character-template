@icon("res://addons/plenticons/icons/16x/2d/diamond-yellow.png")
extends Node
class_name CharacterControllerState

var state_machine: CharacterControllerStateMachine
var actor: CharacterBody2D

var is_active := false

func enter(_from, _data):
	pass


func exit(_to, _data):
	pass


func render_tick(_delta):
	pass


func physics_tick(_delta):
	pass
