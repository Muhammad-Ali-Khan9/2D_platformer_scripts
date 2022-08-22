extends Button

func _on_main_menu_button_pressed():
	get_tree().change_scene("res://Control.tscn") # Replace with function body.

func _on_restart_button_pressed():
	Global.lives = Global.max_lives
	get_tree().change_scene("res://lev1.tscn")
