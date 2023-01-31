extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var startingVelocity = 200
var direction = 0
var damage = 0

func init_sphere(projPosition, projectileRadians, projSpeed, projDamage):
	position = projPosition
	direction = projectileRadians
	startingVelocity = projSpeed
	damage = projDamage

# Called when the node enters the scene tree for the first time.
#func _ready():
#	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.UP * startingVelocity
	position += velocity * delta
