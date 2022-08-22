extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	visible = false


var is_paused = false setget _set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = not is_paused
		visible = is_paused

func _set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = true

func _on_resume_game_pressed():
	self.is_paused = false
	visible = false


func _on_main_menu_button_pressed():
	visible = false
	self.is_paused = false
	get_tree().change_scene("res://Control.tscn")
