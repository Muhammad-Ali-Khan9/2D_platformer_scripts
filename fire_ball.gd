extends KinematicBody2D

var direction = 1
var velocity = Vector2()
const SPEEED = 800
const GRAVITY = 22
const BOUNCE = -300

func _ready():
	velocity.x = SPEEED * direction

func _physics_process(_delta):
	
	$Sprite.rotation_degrees += 25 * direction
	velocity.y += GRAVITY
	
	if is_on_wall():
		queue_free()
		
	if is_on_floor():
			velocity.y = BOUNCE
	
	velocity = move_and_slide(velocity,Vector2.UP)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Timer_timeout():
	$AudioStreamPlayer.play()
