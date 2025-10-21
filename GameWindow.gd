extends Control


@onready var click_quit_button: TextureButton = $GameWindow/VBoxContainer/HBoxContainer/QuitButton


func _ready() -> void:
	click_quit_button.pressed.connect(_onQuitButtonPressed)
	


func _onQuitButtonPressed():
	queue_free()
