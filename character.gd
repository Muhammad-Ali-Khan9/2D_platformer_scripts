extends KinematicBody2D

enum states { AIR=1, FLOOR, LADDER, WALL }
var last_jump_direction = 0
var state = states.FLOOR 
var direction = 1
var lef_over = 0
var coins = 0
var on_ladder := false
var velocity = Vector2(0,-1)
const SPEED = 280
const RUN_SPEED = 500
const JUMP_FORCE = -970
const GRAVITY = 35
const PUSH = 20
const FIREBALL = preload("res://fire_ball.tscn")


func _physics_process(_delta):
	
	match state:
		states.AIR:
			if is_on_floor() and velocity.y == 0:
				last_jump_direction = 0
				state = states.FLOOR
				continue
			elif is_near_wall():
				state = states.WALL
				continue
			
			elif should_climb_ladder():
				state = states.LADDER
				continue
				
			$Sprite.play("jump")
			if Input.is_action_pressed("right"):
				velocity.x = lerp(velocity.x,SPEED,0.1) if velocity.x < SPEED else lerp(velocity.x,SPEED,0.03)
				$Sprite.flip_h = false
	
			elif Input.is_action_pressed("left"):
				velocity.x = lerp(velocity.x,-SPEED,0.1) if velocity.x > SPEED else lerp(velocity.x,-SPEED,0.03)
				$Sprite.flip_h = true
	
			else:
				velocity.x = lerp(velocity.x,0,0.2)
			
			set_direction()
			move_and_fall(false)
			fire()
			
		states.FLOOR:
			if not is_on_floor():
				state = states.AIR
				continue
				
			elif should_climb_ladder():
				state = states.LADDER
				continue
			
			if Input.is_action_pressed("right"):
				
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x,RUN_SPEED,0.1)
					$Sprite.set_speed_scale(1.8)
				else:
					velocity.x = lerp(velocity.x,SPEED,0.1)
					$Sprite.set_speed_scale(1.0)
				$Sprite.play("run")
				$Sprite.flip_h = false
			
			elif Input.is_action_pressed("left"):
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x,-RUN_SPEED,0.1)
					$Sprite.set_speed_scale(1.8)
				else:
					velocity.x = lerp(velocity.x,-SPEED,0.1)
					$Sprite.set_speed_scale(1.0)
				$Sprite.play("run")
				$Sprite.flip_h = true
			else:
				$Sprite.play("idle")
				velocity.x = lerp(velocity.x,0,0.2)
					
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_FORCE
				$jump_sound.play()
				state = states.AIR
			
			set_direction()
			move_and_fall(false)
			fire()
		
		states.LADDER:
			
			if not on_ladder:
				state = states.AIR
				continue 
			elif is_on_floor() and Input.is_action_pressed("down") and velocity.y == 0:
				state = states.FLOOR
				Input.action_release("down")
				Input.action_release("up")
				continue
			elif Input.is_action_just_pressed("jump"):
				Input.action_release("down")
				Input.action_release("up")
				velocity.y = JUMP_FORCE * 0.7
				state = states.AIR
				continue
				
			if Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				$Sprite.play("climb")
			else:
				$Sprite.stop();
			
			if Input.is_action_pressed("up"):
				velocity.y = -SPEED/2
				
			elif Input.is_action_pressed("down"):
				velocity.y = SPEED/2
				
			else:
				velocity.y = lerp(velocity.y,0,0.3)
	
			if Input.is_action_pressed("left"):
				velocity.x = -SPEED/6
			elif Input.is_action_pressed("right"):
				velocity.x = SPEED/6
			else:
				velocity.x = lerp(velocity.x,0,0.7)
			
			velocity = move_and_slide(velocity,Vector2.UP)
			
		states.WALL:
			if is_on_floor():
				last_jump_direction = 0
				state = states.FLOOR
				continue
			elif not is_near_wall():
				state = states.AIR
				continue
			
			$Sprite.play("wall")
			
			if $Sprite.flip_h:
				direction = -1
			else:
				direction = 1
			
			if direction != last_jump_direction and (Input.is_action_pressed("jump")) and ((Input.is_action_pressed("left") and direction == 1) or (Input.is_action_pressed("right") and direction == -1)):
				last_jump_direction = direction
				velocity.x = 450 * -direction
				velocity.y = JUMP_FORCE * 0.7
				$jump_sound.play()
				state = states.AIR 
				
			move_and_fall(true)
			
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func should_climb_ladder() -> bool:
	if on_ladder and (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		return true
	else:
		return false
		
func is_near_wall():
	return $WallChecker.is_colliding() and not $WallChecker.get_collider().is_in_group("one_way")

func set_direction():
	
	var direction = 1 if not $Sprite.flip_h else  -1
	$WallChecker.rotation_degrees = 90 * -direction

func fire():
	if Input.is_action_just_pressed("fire") and not is_near_wall():
		var f = FIREBALL.instance()
		var direction = 1 if not $Sprite.flip_h else  -1
		f.direction = direction
		get_parent().add_child(f)
		f.position.y = position.y
		f.position.x = position.x + 15 * direction
		
# Called when the node enters the scene tree for the first time.
 # Replace with function body.

func move_and_fall(slow_fall : bool):
	velocity.y = velocity.y + GRAVITY
	
	if slow_fall:
		velocity.y = clamp(velocity.y,JUMP_FORCE,160)
		
	velocity = move_and_slide(velocity,Vector2.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# pass
func _on_fall_zone_body_entered(_body):
	Global.lose_life()
	if Global.lives >= 1:
		_body.position = CheckPoints.last_checkpoint


func bounce():
	velocity.y = JUMP_FORCE * 0.4
	
func ouch(var enemyposx):
	Global.lose_life()
	set_modulate(Color(1,0.3,0.3,0.3))
	velocity.y = JUMP_FORCE * 0.3

	if position.x < enemyposx:
		velocity.x = -1000
	
	elif position.x > enemyposx:
		velocity.x = 1000
	
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("jump")
	
	$Timer.start(0.5)

func _on_Timer_timeout():
	set_modulate(Color(1,1,1,1))
	
	
func hurt(var enemyposx):
	Global.lose_life()
	set_modulate(Color(1,0.3,0.3,0.3))
	
	if position.x < enemyposx:
		velocity.x = -PUSH
	
	elif position.x > enemyposx:
		velocity.x = PUSH
	
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("jump")
	
	$Timer.start(0.5)


func _on_ladder_checker_body_entered(_body):
	on_ladder = true


func _on_ladder_checker_body_exited(_body):
	on_ladder = false
