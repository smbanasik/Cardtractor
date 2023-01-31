extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var startingVelocity = 200
export var direction = 0

func _init(projPosition, projDirection, projSpeed, projDamage):
	position = projPosition
	direction = projDirection

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.UP.rotated(direction) * startingVelocity
	
	position += velocity * delta
