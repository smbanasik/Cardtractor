extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size
export var angelSpeed = 200
# Max distance an angel can randomly move
export var angelMaxDistance = 60
# This system will likely be replaced by emitters
export var projectileSpeed = 100
export var projectileDamage = 1
var projectileRadians = PI
var hasAngelFired = true
#var coolDownSpeed = 0.1
#var coolDowntime = coolDownSpeed
# Time in seconds
var thinkTimeVal = 2
# Ai related things
var angelTargetPoint = Vector2()
var targetArray = []
var waitArray = []
var useTargetArray = false

signal angelHit
signal angelFiring(projTeam, projectilePosition, projectileRadians, projectileSpeed, projectileDamage)

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
#	monitoring = true
	if useTargetArray == false:
		$ThinkTime.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	# TODO: Change to interpolation method and see if can change 
	# method of firing???
	# Interpolation makes angels more natural, kind of like animals, 
	# not sure how to utilize with current vars though.
	# Will need to play with it more, for now I think what we have is *okay*
	#t += delta * 0.4
	#position = position.linear_interpolate(angelTargetPoint, delta)
	
	# Angel moves to ThinkPoint
	if position.distance_to(angelTargetPoint) > 2:
		velocity = position.direction_to(angelTargetPoint) * angelSpeed
	else:
		# We've hit to our point, if we're using a target array, we should start our timer.
		if useTargetArray == true:
			$ThinkTime.start()
		
		# If we haven't fired, go ahead and do so
		if hasAngelFired == false:
			hasAngelFired = true
			# Causes angel to track player
			#$Emitter.startingAngle = position.direction_to(get_node("/root/BulletHell/Player").position)
			#print(get_node("/root/BulletHell/Player").position)
			$Emitter.emitterFire()
			#emit_signal("angelFiring", "enemy", position, projectileRadians, projectileSpeed, projectileDamage)
		
	position += velocity * delta
	
	# Prevent angel from moving off screen by ensuring the value remains
	# between the min (0), and max (screen size)
	if useTargetArray == false:
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)

# Initialize angel things
func init_angel(startPos, angelThinkTimeVal, angelMaxMoveDistance, angelUseTargetArray):
	position = startPos
	angelTargetPoint = startPos
	$ThinkTime.wait_time = angelThinkTimeVal
	thinkTimeVal = angelThinkTimeVal
	angelMaxDistance = angelMaxMoveDistance
	useTargetArray = angelUseTargetArray
	
#Initialize a path for the angel to follow.
func init_angelTargetArray(angelTargetArray, angelWaitArray):
	targetArray = angelTargetArray
	waitArray = angelWaitArray
	# Set our initial values
	if targetArray.size() > 0 and waitArray.size() > 0:
		angelTargetPoint = targetArray.front()
		$ThinkTime.wait_time = waitArray.front()
		$ThinkTime.stop()

# AI stuff
func _on_ThinkTime_timeout():
	
	# The assumption is that we've moved to where we wanted to go and have waited the amount of time
	# and we are ready to move to the next point
	if useTargetArray == true:
		# Make sure we still have values left to parse
		if targetArray.size > 0:
			
			# Based on our assumption, we need to move to the next area,
			# so pop our current one out and get the next one
			targetArray.pop_front()
			angelTargetPoint = targetArray.front()
			# Same thing for waiting
			waitArray.pop_front()
			$ThinkTime.wait_time = waitArray.front()
			$ThinkTime.stop()
			
		# If we don't reset the timer to thinkTimeVal
		else:
			useTargetArray = false
			$ThinkTime.wait_time = thinkTimeVal
			$ThinkTime.start()
	
	# If we're not using the array, random number generate
	else:
		$ThinkTime.wait_time = thinkTimeVal
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		
		# Angel picks a direction
		var angelRadians = rng.randf_range(0, 2*PI)
		# Angel picks a distance
		rng.randomize()
		var angelDistance = rng.randf_range(25, angelMaxDistance)
		
		# Angel moves a normalized vector * distance in the direction
		var angelVector = Vector2.RIGHT.rotated(angelRadians) * angelDistance
		
		# Current position + vector = thinkPoint, clamped from 0 : screensize
		angelTargetPoint = position + angelVector
		#print(position)
		#print(angelTargetPoint)
		angelTargetPoint.x = clamp(angelTargetPoint.x, 0, screen_size.x)
		angelTargetPoint.y = clamp(angelTargetPoint.y, 0, screen_size.y)
		
	# Regardless of what we do, reset our firing.
	hasAngelFired = false
	pass

func _on_Angel_area_entered(area):
	# If it's a player projectile
	if area.is_in_group("player"):
		hide()
		$HitBox.set_deferred("disabled", true)
		# Not sure how to handle death animations, but I assume we call a function that will go through it, and when a variable reaches its max, we remove it.
		# For now though, we'll just remove it.
		emit_signal("angelHit")
		queue_free()
		# Delete projectile that hit us
		area.queue_free()
