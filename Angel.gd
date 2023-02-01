extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size
export var angelSpeed = 200
export var angelMaxDistance = 10
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
	
	# Angel moves to ThinkPoint
	if self.position != $ThinkPoint.position:
		
		pass
	
	# Prevent angel from moving off screen by ensuring the value remains
	# between the min (0), and max (screen size)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

# Something collides with angel, kill it
func _on_Angel_body_entered(body):
	$HitBox.set_deffered("disabled", true)

# AI stuff
func _on_ThinkTime_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Angel picks a direction
	var angelRadians = rng.randf_range(0, 2*PI)
	# Angel picks a distance
	rng.randomize()
	var angelDistance = rng.randf_range(0, angelMaxDistance)
	
	# Angel moves a normalized vector * distance in the direction
	var angelVector = Vector2.UP.rotated(angelRadians) * angelDistance
	
	# Current position + vector = thinkPoint, clamped from 0 : screensize
	$ThinkPoint.position = self.position + angelVector
	$ThinkPoint.position.x = clamp($ThinkPoint.position.x, 0, screen_size.x)
	$ThinkPoint.position.y = clamp($ThinkPoint.position.y, 0, screen_size.y)
	
	pass
