extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var projectileSphere


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _on_Player_playerFiring(projectilePosition, projectileDirection, projectileSpeed, projectileDamage):
	projectileSphere.instance()
	projectileSphere.init()
	add_child(projectileSphere)
