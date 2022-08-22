extends Node

var hud 
var max_lives = 3
var lives = max_lives

func lose_life():
	lives -= 1
	hud.load_hearts()
	
	if lives <= 0:
		get_tree().change_scene("res://game_over.tscn")
