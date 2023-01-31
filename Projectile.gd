extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var startingVelocity = 200
export var direction = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Projectile Spawned!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.UP.rotated(direction) * startingVelocity
	
	position += velocity * delta
