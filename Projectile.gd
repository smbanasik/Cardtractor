extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var startingVelocity = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Projectile Spawned!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = startingVelocity * delta
