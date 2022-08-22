extends StaticBody2D

var above_ladder := false 


func _physics_process(delta):
	if Input.is_action_pressed("down") and (above_ladder):
		$CollisionShape2D.rotation_degrees = 180
	#else:
		#$CollisionShape2D.disabled = false
		
func _on_Area2D_body_entered(body):
		above_ladder = true


func _on_Area2D_body_exited(body):
	above_ladder = false
	$CollisionShape2D.rotation_degrees = 0



