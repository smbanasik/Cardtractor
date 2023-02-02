extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wave = 1
var maxWave = 1
# Expressed as a percentage
var waveSpawnProgress = 0
var level = 1
var difficulty = 0

# Records start of level
var levelStartTime = 0
# Records the start of a wave
var waveStartTime = 0
# Records current time
var levelCurrentTime = 0
# Records any time between start & current time
var levelInterTime = 0

# Send an string enemy type, an array of enemy values, and a 2d array of positions & wait times
signal spawnEnemy(enemyType, enemyData, enemyMovement)
signal endLevel(level)
# Called when the node enters the scene tree for the first time.
#func _ready():
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if levelStartTime > 0:
		levelCurrentTime = Time.get_ticks_msec()
		
		# TODO: Optimize this further, take into account if it's time to spawn the next creature or not
		# If we haven't spawned the whole wave, go through it.
		if waveSpawnProgress < 100:
			levelDecider()

# Starting a level
func _on_Node2D_startLevel(signalDifficulty, signalLevel):
	difficulty = signalDifficulty
	levelStartTime = Time.get_ticks_msec()
	waveStartTime = levelStartTime
	level = signalLevel
	wave = 1
	waveSpawnProgress = 0

# We've cleared a wave
func _on_BulletHell_waveClear():
	wave += 1
	waveSpawnProgress = 0
	waveStartTime = levelCurrentTime
	if wave > maxWave:
		emit_signal("endLevel", level)

# Decides which level function to use
func levelDecider():
	match [level]:
		[1]:
			levelOne()
		[2]:
			pass
		[3]:
			pass
		[4]:
			pass

func levelOne():
	maxWave = 5
	
	var angelData = [Vector2(0, 0), 1, 100, false]
	
	match [wave]:
		[_]:
			if (levelInterTime == 0):
					levelInterTime = levelCurrentTime
			# Spawn in two enemies that don't use AI at the right of the screen
			if (waveSpawnProgress < 50 and levelCurrentTime - levelInterTime > 200):
				angelData[0] = Vector2(1000 - waveSpawnProgress * 1.5, 200 + waveSpawnProgress / 2)
				emit_signal("spawnEnemy", "angel", angelData, [[], []])
				angelData[0] = Vector2(1000 - waveSpawnProgress * 1.5, 500 - waveSpawnProgress / 2)
				emit_signal("spawnEnemy", "angel", angelData, [[], []])
				waveSpawnProgress += 10
				levelInterTime = levelCurrentTime
			if (levelCurrentTime - waveStartTime > 5000):
				angelData[0] = Vector2(1200, 200)
				emit_signal("spawnEnemy", "angel", angelData, [[], []])
				angelData[0] = Vector2(1200, 500)
				emit_signal("spawnEnemy", "angel", angelData, [[], []])
				
				# IMPORTANT
				waveSpawnProgress = 100
				# Not important, doing for sake of testing
				levelInterTime = 0
	
	pass
