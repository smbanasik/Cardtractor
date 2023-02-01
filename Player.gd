extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screen_size
export var playerSpeed = 200
export var playerFastMultiplier = 0.5
var playerLives =  5
export var projectileBaseSpeed = 500
export var projectileDamage = 1
var projectileRadians = 0
var coolDownSpeed = 0.1
var coolDowntime = coolDownSpeed

var playerBlinkTicks = 0

# Our player was hit by something!
signal playerHit(playerLives)
signal playerFiring(projTeam, projectilePosition, projectileRadians, projectileSpeed, projectileDamage)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
#	monitoring = true
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
		emit_signal("playerFiring", "player", position + $ProjectilePoint.position, projectileRadians, projectileSpeed, projectileDamage)
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
	
	# Damage
	if playerBlinkTicks > 0:
		playerDamage()

func _on_Player_area_entered(area):
	if area.is_in_group("enemy"):
		# Player does things on being hit, like play an animation or sound
		# For now it just disappears
		
		playerLives -= 1
		emit_signal("playerHit", playerLives)
		playerBlinkTicks = 80
		
		# Disable collision to prevent multiple hits
		# Set deffered to prevent uh ohs
		$HitBox.set_deferred("disabled", true)
		area.queue_free()
	
func playerDamage():
	
	# We've passed 20 frames, change
	if(playerBlinkTicks % 20 == 0):
		self.visible = !(is_visible()) # TODO: Sawp with ghost sprite instead
	
	playerBlinkTicks -= 1
	
	# Always ensure the player is visible at the end
	# and enable hitbox
	if(playerBlinkTicks <= 0):
		self.visible = true
		$HitBox.set_deferred("disabled", false)
	
