extends StaticBody2D

@export var type: String = "empty"
var hp = 2



func _ready():
	match type:
		"empty":
			$Sprite2D.texture = preload("res://assets/MiniGames/DomeGuardian/sprite_dg_emptyblock.png")
		"gold":
			$Sprite2D.texture = preload("res://assets/MiniGames/DomeGuardian/sprite_dg_goldblock.png")
	
func hit():
	hp -= 1
	if hp == 1:
		$Sprite2D.modulate = Color(1,0.7,0.7)
	elif hp <= 0:
		if type == "gold":
			AllScores.minigame_score += 1
		queue_free()
	print(AllScores.minigame_score)
