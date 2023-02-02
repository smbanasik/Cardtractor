extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var startingVelocity = 200
var direction = 0
var rotationSpeed = 0.1
var endDirection = 0
var damage = 1

func init_proj(projPosition, projectileStartRadians, projSpeed, projDamage, projRotationSpeed, lifeTime, projectileEndRadians):
	position = projPosition
	direction = projectileStartRadians
	startingVelocity = projSpeed
	damage = projDamage
	rotationSpeed = projRotationSpeed
	$Timer.wait_time = lifeTime
	endDirection = projectileEndRadians

# Called when the node enters the scene tree for the first time.
func _ready():
#	monitorable = true
	$Timer.start()	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.UP.rotated(direction) * startingVelocity
	position += velocity * delta
	if($Timer.time_left > 0):
		direction += rotationSpeed

# Called from VisibilityNotifier2D
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Timer_timeout():
	direction = endDirection
