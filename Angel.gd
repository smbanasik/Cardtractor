extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size
export var angelSpeed = 400
var angelRadians = 0
export var projectileSpeed = 500
export var projectileDamage = 1
var projectileRadians = PI
#var coolDownSpeed = 0.1
#var coolDowntime = coolDownSpeed

signal angelHit
signal angelFiring(projectilePosition, projectileRadians, projectileSpeed, projectileDamage)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$ThinkTime.start


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	# Prevent angel from moving off screen by ensuring the value remains
	# between the min (0), and max (screen size)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

# Something collides with angel, kill it
func _on_Angel_body_entered(body):
	$HitBox.set_deffered("disabled", true)

# AI stuff
func _on_ThinkTime_timeout():
	
	
