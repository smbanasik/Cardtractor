extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var acceleration = 0
var startingVelocity = 200
var direction = Vector2(0, 0)
var damage = 1

func init_proj(projPosition, projectileDirection, projSpeed, projAcel, projDamage):
	position = projPosition
	direction = projectileDirection
	startingVelocity = projSpeed
	acceleration = projAcel
	damage = projDamage

# Called when the node enters the scene tree for the first time.
func _ready():
	#monitorable = true
	monitoring = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	startingVelocity += acceleration * delta
	var velocity = direction * startingVelocity
	position += velocity * delta

# Called from VisibilityNotifier2D
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
