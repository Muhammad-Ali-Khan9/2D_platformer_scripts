extends Area2D

signal coin_collected

func _on_coin_body_entered(_body):
	$AnimationPlayer.play("animation bounce")
	emit_signal("coin_collected")
	set_collision_mask_bit(0,false)
	$coin_collect_sound.play()
	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
