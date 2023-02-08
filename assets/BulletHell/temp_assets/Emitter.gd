extends Node2D

# Emitters - Will serve as an abstraction between enemies and projectile positioning & such
# - Main will still actually create the projectiles, but this way, it's easier to produce interesting projectile patterns
# - Handle the position, direction, acceleration, starting velocity, and arrays of projectiles.
# - These do not handle projectile curvature or movement once fired. That will be left up to projectile types

# THIS CAN BE CONNECTED TO MAIN, AWESOME!!!!
signal emitProjectile(projArray)

# How many bullet streams
export var bulletArrays = 1
# Spread in between the arrays, by default 180 degrees
export var bulletArrSpread = PI
# How many bullets per an array?
export var bulletArrNum = 1
# The spread between the bullets within the array
export var bulletArrNumSpread = PI
# When fired, which direction do bullets go?
export var startingAngle = Vector2.LEFT
var bulletAngle = startingAngle
# Uses polar coordinates (radius and angle offset from center), for example, a distance of 3 with an angle of pi
export var centerOffset = Vector2(0, 0)
# Do bullets speed up / slow down / referse? How fast when they start?
export var acceleration = 0
export var velocity = 100
# Should the emitter spin?
# Add functions that let this be modified
export var spinRate = 0
export var spinMax = 0
# Changes the rate in which emitter spin
export var spinMod = 0
# Might not be used since we just cull when off screen. We'll see
#var lifeTime
# Controlls how frequently bullets should fire in ms
#var fireRate = 1000
# Sets the bullet type
export var bulletType = "basic"
# Team that the projectile is on
export var projTeam = "enemy"

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Any smooth emitter movement functions should go into here probably.
	emitterSpin()
	pass
	
# Produce a projectile based on the current position of the character firing it
func emitterFire():
	# We'll pass an array of variables through the signal to a projectile depending on the type
	var fireArr = []
	
	# Get position of parent node
	var emitPosition = get_parent().position
	
	fireArr.push_back(emitPosition)
	fireArr.push_back(startingAngle)
	fireArr.push_back(velocity)
	fireArr.push_back(acceleration)
	
	emit_signal("emitProjectile", fireArr)
	pass

# Handles the spinning of the projectile
func emitterSpin():
	var isNegative = false
	
	# Handle change in spin rate
	if spinMod != 0:
		
		spinRate += spinMod
		
		if spinRate < 0:
			isNegative = true
		
		if abs(spinRate) > spinMax:
			spinRate = spinMax
		
		# Make sure we're not magically becoming positive
		if isNegative == true && spinRate > 0:
			spinRate = -spinRate
		pass
	
	# Handle spinning if spinning
	if spinRate != 0:
		startingAngle = startingAngle.rotated(spinRate)
		pass
	
	pass
	
# Sets the spinRate and spinMod to 0
# Takes in an angle based on a vector pointing to the right (like in math)
# To point it left, use PI as your input
func emitterResetSpin(angle):
	spinRate = 0
	spinMod = 0
	startingAngle = Vector2.RIGHT.rotated(angle)
	pass
