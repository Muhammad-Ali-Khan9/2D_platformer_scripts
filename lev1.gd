extends Node2D

func _enter_tree():
	if CheckPoints.last_checkpoint:
		$character.global_position = CheckPoints.last_checkpoint
