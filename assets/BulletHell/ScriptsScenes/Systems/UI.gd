extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Take in an array, use it to set text of UI
func initUIText(textArr):
	
	if textArr.size() != 6:
		print("Array size for UIText is bad! Bad programming!")
	else:
		var index = 0
		for N in $UIText.get_children():
			
			N.text = textArr[index]
			
			index += 1
	
# Initialize values of things
func initUIVars(gameLevel, lives):
	$UIText/GameLevel.text += str(gameLevel)
	$UIText/Lives.text += str(lives)
	pass

# Take in an array and update the UI
func updateUI(cardTimeVal, scoreVal, livesVal, playerLevelVal, levelTimeVal):
	$UIText/CardsTimer.text += cardTimeVal
	$UIText/score.text += scoreVal
	$UIText/Lives.text += livesVal
	$UIText/PlayerLevel.text += playerLevelVal
	$UIText/LevelTime.text += levelTimeVal
	
	pass
