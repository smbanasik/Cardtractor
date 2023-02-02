extends Node2D

# REMINDER FOR ORION: SHADERS = POLISH.

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# THINGS TO DO:
# Emitters - Will serve as an abstraction between enemies and projectile positioning & such
# - Main will still actually create the projectiles, but this way, it's easier to produce interesting projectile patterns
# - Handle the position, direction, damage, acceleration, starting velocity, and arrays of projectiles.
# - These do not handle projectile curvature or movement once fired. That will be left up to projectile types
# - Wants: These may or may not be possible, but ideally this is how it works
# - I want emitters to be attachable to enemies, so a generic angel may use different types of emitters
# - I want the emitter to recieve when the angel fires and act on that.
# - So we make an emitter scene, we flesh it out, we attach it to an angel. Then what?
# - I don't think we can just make different emitter scenes and attach it to one angel, so the emitter should be robust.
# - One type of emitter, capable of manipulating every aspect of every projectile through different modes/functions.
# - It might get messy, but I can't think of another way right now.
# - This would provide the most flexibility as enemies could use multiple attacks if need be.
# Let enemies use multiple moves?
# Enemy spawning/ level system
# Player leveling :)
# Develop line projectiles
# Utilize beziers and interpolation found here:  https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html
# and get cooler curving projectiles/homing projectiles
# Actually work on the card game
# Rename main to bullet hell
# Work on card format
# Create a main menu

# TODO: Might be better to rip out the timer from angel and replace it with ticks
# for the purposes of firing, waiting, and so on. We'll see.

# PROCESS FOR LETTING ENEMIES USE MULTIPLE MOVES:
# rather than having a signal per enemy, have a signal per projectile (since signals are just strings)
# And handle which move to use inside of enemy ai.
# We can make enemies have different init functions to manage this and connect to the signals we want our enemy to use

export(PackedScene) var projectileSphere
export(PackedScene) var projectileCurved
export(PackedScene) var projectileSine
export(PackedScene) var enemyAngel

var playerScore = 0

signal waveClear
signal startLevel(difficulty, level)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("startLevel", 0, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func _unhandled_input(event):
	if event.is_action_pressed("left_click"):
		emit_signal("startLevel", 0, 1)
#		var angel = enemyAngel.instance()
#		angel.init_angel(get_viewport().get_mouse_position())
#		angel.init_angelTargetArray([Vector2(1000, 20), Vector2(900, 600), Vector2(1100, 200), Vector2(10, 80)])
#		# Connect main to angel's signals
#		angel.connect("angelFiring", self, "_on_Angel_angelFiring")
#		angel.connect("angelHit", self, "_on_Angel_angelHit")
#		add_child(angel)
		
func _on_Angel_angelHit():
	playerScore += 10
	print("+1 kills!")
		
func _on_Angel_angelFiring(projTeam, projectilePosition, projectileRadians, projectileSpeed, projectileDamage):
	var angelSphere = projectileSphere.instance()
	angelSphere.init_proj(projectilePosition, projectileRadians, projectileSpeed, projectileDamage)
	angelSphere.add_to_group(projTeam)
	add_child(angelSphere)

func _on_Player_playerFiring(projTeam, projectilePosition, projectileRadians, projectileSpeed, projectileDamage):
	#var projSphere = projectileSphere.instance()
	#projSphere.init_proj(projectilePosition, projectileRadians, projectileSpeed, projectileDamage)
	#add_child(projSphere)
	
	var projSine = projectileSine.instance()
	projSine.init_proj(projectilePosition, projectileRadians, projectileSpeed, projectileDamage, 0.2, 1)
	projSine.add_to_group(projTeam)
	add_child(projSine)


func _on_EnemyManager_spawnEnemy(enemyType, enemyData, enemyMovement):
	var createdEnemy
	
	match [enemyType]:
		["angel"]:
			createdEnemy = enemyAngel.instance()
			createdEnemy.init_angel(enemyData[0], enemyData[1], enemyData[2], enemyData[3])
			createdEnemy.init_angelTargetArray(enemyMovement[0], enemyMovement[1])
			# Connect main to angel's signals
			createdEnemy.connect("angelFiring", self, "_on_Angel_angelFiring")
			createdEnemy.connect("angelHit", self, "_on_Angel_angelHit")
			add_child(createdEnemy)
			pass
	
