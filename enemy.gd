extends KinematicBody2D

var speed = 50
var velocity = Vector2()
export var direction = 1
export var detects_cliffs = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detects_cliffs 
	
	if detects_cliffs:
		set_modulate(Color(1.6,0.5,1))
	
func _physics_process(delta):
	
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction

	velocity.y += 20
	
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity,Vector2.UP)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_top_checker_body_entered(body):
	if body.get_collision_layer() == 1:
		$AnimatedSprite.play("squashed")
		speed = 0
		set_collision_layer_bit(4,false)
		set_collision_mask_bit(0,false)
		$top_checker.set_collision_layer_bit(4,false)
		$top_checker.set_collision_mask_bit(0,false)
		$left_checker.set_collision_layer_bit(4,false)
		$left_checker.set_collision_mask_bit(0,false)
		$right_checker.set_collision_layer_bit(4,false)
		$right_checker.set_collision_mask_bit(0,false)
		$Timer.start(1)
		body.bounce()
		$sound_squash.play()
	elif body.get_collision_layer() == 32:
		body.queue_free()
		queue_free()


func _on_left_checker_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x)
	elif body.get_collision_layer() == 32:
		body.queue_free()
		queue_free()

func _on_right_checker_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch(position.x)
	elif body.get_collision_layer() == 32:
		body.queue_free()
		queue_free()


func _on_Timer_timeout():
	queue_free()

func _on_bottom_checker_body_entered(body):
	if body.get_collision_layer() == 1:
		body.hurt(position.x)
	elif body.get_collision_layer() == 32:
		body.queue_free()
		queue_free()
