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


extends Node2D

export(PackedScene) var projectileSphere
export(PackedScene) var projectileCurved
export(PackedScene) var projectileSine
export(PackedScene) var enemyAngel

var waveEnemies = 0
var enemiesKilled = 0
var startTime = 0
var currentTime = 0
# TEMP VAR, eventuall use timer
var cardTimer = 0
var playerLives = 5
var playerLevel = 0
var playerScore = 0

signal waveClear
signal startLevel(difficulty, level)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the size of the screen and set our background to it
	$ParallaxBackground/FarthestBack/Background.rect_size = get_viewport_rect().size
	$ParallaxBackground/CloudsGround/Background.rect_size = get_viewport_rect().size
	$ParallaxBackground/MidGround/Background.rect_size = get_viewport_rect().size
	# Ensure our offset is 0,0 so top of background matches top of screen
	$ParallaxBackground.scroll_base_offset = Vector2(0, 0)
	# Set our motion mirroring to the screen size so the transition is smooth.
	$ParallaxBackground/FarthestBack.motion_mirroring = (get_viewport_rect().size)
	$ParallaxBackground/CloudsGround.motion_mirroring = (get_viewport_rect().size)
	$ParallaxBackground/MidGround.motion_mirroring = (get_viewport_rect().size)
	# Set different scroll speeds
	$ParallaxBackground/FarthestBack.motion_scale.x = 1
	$ParallaxBackground/CloudsGround.motion_scale.x = 1.5
	$ParallaxBackground/MidGround.motion_scale.x = 3
	
	# Update UI with life count and game level 
	$UserInterface.initUIVars(1, playerLives)
	startTime = Time.get_ticks_msec()
	
	# Start our first level
	emit_signal("startLevel", 0, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	currentTime = Time.get_ticks_msec()
	
	var elapsedTime = (currentTime - startTime) / 1000
	$UserInterface.updateUI(cardTimer, playerScore, playerLives, playerLevel, elapsedTime)
	
	$ParallaxBackground.scroll_offset.x -= 20 * delta
	pass
	# Check if enemies are dead, if so, run wave clear
	# if recieve end level signal, do end level things

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		get_tree().quit()
#		emit_signal("startLevel", 0, 1)
#		var angel = enemyAngel.instance()
#		angel.init_angel(get_viewport().get_mouse_position())
#		angel.init_angelTargetArray([Vector2(1000, 20), Vector2(900, 600), Vector2(1100, 200), Vector2(10, 80)])
#		# Connect main to angel's signals
#		angel.connect("angelFiring", self, "_on_Angel_angelFiring")
#		angel.connect("angelHit", self, "_on_Angel_angelHit")
#		add_child(angel)
		
func _on_Angel_angelHit():
	#hitStop(0.2, 0.3)
	playerScore += 10
	$Player.experience += 5
	print("+1 kills!")
	enemiesKilled += 1
	if enemiesKilled >= waveEnemies:
		emit_signal("waveClear")

func _on_Player_playerHit(playerLives):
	hitStop(0.1, 0.4)
	self.playerLives = playerLives
	# lol
	if(playerLives <= 0):
		#get_tree().quit()
		pass
	
	pass # Replace with function body.
		
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
			#createdEnemy.connect("angelFiring", self, "_on_Angel_angelFiring")
			createdEnemy.connect("angelHit", self, "_on_Angel_angelHit")
			createdEnemy.get_node("Emitter").connect("emitProjectile", self, "_on_AngelEmitter_emitFire")
			add_child(createdEnemy)
			pass
	
	# TODO: Current method allows for a bug where if all enemies are killed fast enough, the wave is cleared.
	# Might be desireable, if not, can fix.
	waveEnemies += 1

func _on_AngelEmitter_emitFire(fireArr):
	var angelSphere = projectileSphere.instance()
	angelSphere.init_proj(fireArr[1], fireArr[4], fireArr[2], fireArr[3], 1)
	angelSphere.add_to_group(fireArr[0])
	add_child(angelSphere)
	pass

func _on_EnemyManager_endLevel(level):
	print("Level ended, moving on to level: " + str(level))
	#Handle next level things
	pass
	
	
# Example, 0.1, 0.4 seconds or so
func hitStop(timeScale, duration):
	# Lower time scale to value
	Engine.time_scale = timeScale
	# Create a timer and wait until it's timeout occurs
	yield(get_tree().create_timer(duration * timeScale), "timeout")
	Engine.time_scale = 1.0
