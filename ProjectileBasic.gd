extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var startingVelocity = 200
var direction = 0
var damage = 1

func init_proj(projPosition, projectileRadians, projSpeed, projDamage):
	position = projPosition
	direction = projectileRadians
	startingVelocity = projSpeed
	damage = projDamage

# Called when the node enters the scene tree for the first time.
#func _ready():
#	monitorable = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.UP.rotated(direction) * startingVelocity
	position += velocity * delta

# Called from VisibilityNotifier2D
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
