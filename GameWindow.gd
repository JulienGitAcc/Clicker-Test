extends Control

@export var game_scene: PackedScene

var game_instance: Node = null

@onready var click_quit_button: TextureButton = $GameWindow/VBoxContainer/HBoxContainer/QuitButton



func _ready() -> void:
	click_quit_button.pressed.connect(_onQuitButtonPressed)
	load_game()


func load_game():
	if game_scene:
		game_instance = game_scene.instantiate()
		$GameWindow/VBoxContainer/GameContainer.add_child(game_instance)
	else:
		print("erreur: aucune scène de jeu assignée")


func _onQuitButtonPressed():
	AllScores.money += AllScores.minigame_score
	AllScores.minigame_score = 0
	queue_free()
	
