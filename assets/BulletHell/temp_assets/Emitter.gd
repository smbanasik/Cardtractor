extends Node2D

# How many bullet streams
var bulletArrays = 1
# Spread in between the arrays, by default 180 degrees
var bulletArrSpread = PI
# How many bullets per an array?
var bulletArrNum = 1
# The spread between the bullets within the array
var bulletArrNumSpread = PI
# When fired, which direction do bullets go?
var startingAngle = 0
# Uses polar coordinates (radius and angle offset from center), for example, a distance of 3 with an angle of pi
var centerOffset = Vector2(0, 0)
# Do bullets speed up / slow down / referse? How fast when they start?
var acceleration = 0
var velocity = 100
# Should the emitter spin?
# Add functions that let this be modified
var spinRate = 0
var maxSpin = 0
# Changes the rate in which emitter spin
var spinMod = 0
# Might not be used since we just cull when off screen. We'll see
#var lifeTime
# Controlls how frequently bullets should fire in mS
var fireRate = 1000
# Sets the bullet type
var bulletType

# Emitters - Will serve as an abstraction between enemies and projectile positioning & such
# - Main will still actually create the projectiles, but this way, it's easier to produce interesting projectile patterns
# - Handle the position, direction, damage, acceleration, starting velocity, and arrays of projectiles.
# - These do not handle projectile curvature or movement once fired. That will be left up to projectile types
# - Wants: These may or may not be possible, but ideally this is how it works
# - I want emitters to be attachable to enemies, so a generic angel may use different types of emitters
# - I want the emitter to recieve when the angel fires and act on that.
# - So we make an emitter scene, we flesh it out, we attach it to an angel. Then what?
# - I don't think we can just make different emitter scenes and attach it to one angel, so the emitter should be robust.
# - One type of emitter, capable of manipulating every aspect of every projectile through different modes/functions.
# - It might get messy, but I can't think of another way right now.
# - This would provide the most flexibility as enemies could use multiple attacks if need be.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Initialize parameters like offset from
func emitterInit():
	pass
	
# Produce a projectile 
func emitterFire():
	pass
