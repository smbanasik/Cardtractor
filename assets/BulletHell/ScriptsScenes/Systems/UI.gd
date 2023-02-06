extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Array of stored UI text.
var uiText = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for N in $UIText.get_children():
		uiText.push_back(N.text)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Take in an array, use it to set text of UI
func initUIText(textArr):
	
	if textArr.size() != 6:
		print("Array size for UIText is bad! Bad programming!")
	else:
		uiText = textArr
		
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
	$UIText/CardsTimer.text = uiText[0] + str(cardTimeVal)
	$UIText/Score.text = uiText[1] + str(scoreVal)
	$UIText/Lives.text = uiText[3] + str(livesVal)
	$UIText/PlayerLevel.text = uiText[4] + str(playerLevelVal)
	$UIText/LevelTime.text = uiText[5] + str(levelTimeVal)
	
	pass
