extends Control

var amplitude = 10
var duration = 1
var direction = -1


@onready var new_game_button = $NewGameButton
@onready var game_name = $HBoxContainer
@onready var exit_game_button = $ExitGameButton


func _ready() -> void:
	new_game_button.pressed.connect(_on_NewGameButton_pressed)
	exit_game_button.pressed.connect(_on_exit_button_pressed)
	game_name.position.y = -game_name.size.y
	var target_position = 400
	
	var tween  = create_tween()
	tween.tween_property(game_name, "position:y", target_position, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func():_loop_bounce())
	
func _on_NewGameButton_pressed():
	get_tree().change_scene_to_file("res://game.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _loop_bounce():
	var start_y = 400
	var target_y = start_y + amplitude * direction
	var tween = create_tween()
	tween.tween_property(game_name, "position:y", target_y, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(func():
		direction *= -1
		_loop_bounce()
		)
		
