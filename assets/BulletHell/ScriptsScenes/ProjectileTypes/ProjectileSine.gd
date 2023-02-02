extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var startingVelocity = 200
var direction = 0
var damage = 1
var density = 0
var amp = 1
var tick = 0

func init_proj(projPosition, projectileRadians, projSpeed, projDamage, projDensity, projAmp):
	position = projPosition
	direction = projectileRadians
	startingVelocity = projSpeed
	damage = projDamage
	density = projDensity
	amp = projAmp

# Called when the node enters the scene tree for the first time.
#func _ready():
#	monitorable = true

# Multiplying the cosine wave by numbers in the rotation does *very* interesting things, 10 and 5 are cool.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.UP.rotated(amp * cos(tick) + direction) * startingVelocity
	position += velocity * delta
	tick += density
	
# Called from VisibilityNotifier2D
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
