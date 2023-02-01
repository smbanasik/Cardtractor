extends Node2D

# REMINDER FOR ORION: SHADERS = POLISH.

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# THINGS TO DO:
# todo's in angel & player
# Enemy spawning
# Let enemies use multiple moves?
# Develop line projectiles
# Utilize beziers and interpolation found here:  https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html
# and get cooler curving projectiles/homing projectiles
# Actually work on the card game
# Rename main to bullet hell
# Work on card format
# Create a main menu

# PROCESS FOR LETTING ENEMIES USE MULTIPLE MOVES:
# rather than having a signal per enemy, have a signal per projectile (since signals are just strings)
# And handle which move to use inside of enemy ai.
# We can make enemies have different init functions to manage this and connect to the signals we want our enemy to use

export(PackedScene) var projectileSphere
export(PackedScene) var projectileCurved
export(PackedScene) var projectileSine
export(PackedScene) var enemyAngel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		var angel = enemyAngel.instance()
		angel.init_angel(get_viewport().get_mouse_position())
		# Connect main to angel's signals
		angel.connect("angelFiring", self, "_on_Angel_angelFiring")
		add_child(angel)
		
func _on_Angel_angelFiring(projectilePosition, projectileRadians, projectileSpeed, projectileDamage):
	var angelSphere = projectileSphere.instance()
	angelSphere.init_proj(projectilePosition, projectileRadians, projectileSpeed, projectileDamage)
	add_child(angelSphere)

func _on_Player_playerFiring(projectilePosition, projectileRadians, projectileSpeed, projectileDamage):
	#var projSphere = projectileSphere.instance()
	#projSphere.init_proj(projectilePosition, projectileRadians, projectileSpeed, projectileDamage)
	#add_child(projSphere)
	var projSine = projectileSine.instance()
	projSine.init_proj(projectilePosition, projectileRadians, projectileSpeed, projectileDamage, 0.2, 1)
	add_child(projSine)
