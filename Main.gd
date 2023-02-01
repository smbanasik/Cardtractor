extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var projectileSphere
export(PackedScene) var enemyAngel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		var angel = enemyAngel.instance()
		add_child(angel)


func _on_Player_playerFiring(projectilePosition, projectileRadians, projectileSpeed, projectileDamage):
	var projSphere = projectileSphere.instance()
	projSphere.init_sphere(projectilePosition, projectileRadians, projectileSpeed, projectileDamage)
	add_child(projSphere)
