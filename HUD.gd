extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var coins = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Coins.text = String(coins) 
	load_hearts()
	Global.hud = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(_delta):
	if coins == 8:
		get_tree().change_scene("res://you_win.tscn")

func _on_coin_collected():
	coins = coins + 1
	_ready()
	
func load_hearts():
	$hearts_full.rect_size.x = Global.lives * 53
	$hearts_empty.rect_size.x = (Global.max_lives - Global.lives) * 53
	$hearts_empty.rect_position.x = $hearts_full.rect_position.x + $hearts_full.rect_size.x * $hearts_full.rect_scale.x
