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
var angelTargetPoint = Vector2()
#var coolDownSpeed = 0.1
#var coolDowntime = coolDownSpeed

signal angelHit
signal angelFiring(projectilePosition, projectileRadians, projectileSpeed, projectileDamage)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$ThinkTime.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	# Angel moves to ThinkPoint
	if self.position != angelTargetPoint:
		velocity = position.direction_to(angelTargetPoint) * angelSpeed
		
	position += velocity * delta
	
	# Prevent angel from moving off screen by ensuring the value remains
	# between the min (0), and max (screen size)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

# Something collides with angel, kill it
func _on_Angel_body_entered(body):
	$HitBox.set_deffered("disabled", true)

# Initialize angel things
func init_angel(startPos):
	position = startPos
	angelTargetPoint = startPos

# AI stuff
func _on_ThinkTime_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Angel picks a direction
	#var angelRadians = rng.randf_range(0, 2*PI)
	var angelRadians = PI
	# Angel picks a distance
	rng.randomize()
	#var angelDistance = rng.randf_range(0, angelMaxDistance)
	var angelDistance = 5
	
	# Angel moves a normalized vector * distance in the direction
	var angelVector = Vector2.RIGHT.rotated(angelRadians) * angelDistance
	
	# Current position + vector = thinkPoint, clamped from 0 : screensize
	angelTargetPoint = position + angelVector
	#print(position)
	#print(angelTargetPoint)
	angelTargetPoint.x = clamp(angelTargetPoint.x, 0, screen_size.x)
	angelTargetPoint.y = clamp(angelTargetPoint.y, 0, screen_size.y)
	
	pass
