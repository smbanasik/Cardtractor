extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
	
func emitterFire():
	pass
