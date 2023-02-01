extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size
export var playerSpeed = 200
export var playerFastMultiplier = 0.5
export var projectileBaseSpeed = 500
export var projectileDamage = 1
var projectileRadians = 0
var coolDownSpeed = 0.1
var coolDowntime = coolDownSpeed

# Our player was hit by something!
signal playerHit
signal playerFiring(projectilePosition, projectileRadians, projectileSpeed, projectileDamage)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	#hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	var playerFast = 1
	var projectileSpeed = projectileBaseSpeed # i am angry at you
	coolDowntime -= delta
	
	# Get inputs
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_fast"):
		playerFast = 1 * playerFastMultiplier
		projectileSpeed = projectileSpeed * playerFastMultiplier
	if Input.is_action_pressed("shoot_projectile") and coolDowntime < 0:
		emit_signal("playerFiring", position + $ProjectilePoint.position, projectileRadians, projectileSpeed, projectileDamage)
		coolDowntime = coolDownSpeed
		
	# If we're moving, scale vector to unit length and multiply by speed.
	# This prevents diagonals from moving faster.
	if velocity.length() > 0:
		velocity = velocity.normalized() * playerSpeed * playerFast
		# Animate sprite or something here
		# $ is shorthand for get_node() so $AnimatedSprite is get_node("AnimatedSprite")
	
	# Modify position by speed and time passed
	position += velocity * delta
	
	# Prevent character from moving off screen by ensuring the value remains
	# between the min (0), and max (screen size)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

# Something has contacted the player
func _on_Player_body_entered(body):
	# Player does things on being hit, like play an animation or sound
	# For now it just disappears
	hide()
	emit_signal("hit")
	# Disable collision to prevent multiple hits
	# Set deffered 
	$HitBox.set_deffered("disabled", true)
