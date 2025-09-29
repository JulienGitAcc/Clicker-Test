extends Control

var score: int = 0
var upgrade_1_level: int = 0
var upgrade_1_cost: int = 10
var upgrade_1_shown: bool = false



@onready var click_button: Button = $CenterContainer/VBoxContainer/ClickButton
@onready var score_label: Label = $CenterContainer/VBoxContainer/ScoreLabel
@onready var upgrade_button_1: Button = $HBoxContainer/UpgradeButton1
@onready var upgrade_label_1: Label = $HBoxContainer/UpgradeLabel1
@onready var hitmarker_template = $HitMarker



func _ready() -> void:
	click_button.pressed.connect(_on_ClickButton_pressed)
	upgrade_button_1.pressed.connect(_on_UpgradeButton1_pressed)
	_update_label()
	_update_upgrade_1_level()
	upgrade_button_1.visible = false
	upgrade_label_1.visible = false

func _process(_delta):
	upgrade_button_1.disabled = score < upgrade_1_cost


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		_spawn_hitmarker()
		

func _spawn_hitmarker():
	var marker = hitmarker_template.duplicate()
	add_child(marker)
	marker.visible = true
	marker.position = get_global_mouse_position()
	marker.modulate.a = 1.0
	marker.scale = Vector2(0.035, 0.035)
	
	var tween = create_tween()
	tween.tween_property(marker, "scale", Vector2(0.05, 0.05), 0.05).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(marker, "scale", Vector2(0.035, 0.035), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(marker, "modulate:a", 0.0, 0.1)
	tween.connect("finished", Callable(marker, "queue_free"))
	

func _on_UpgradeButton1_pressed() -> void:
	if score >= upgrade_1_cost:
		score -= upgrade_1_cost
		upgrade_1_level += 1
		upgrade_1_cost = int(10 * pow(1.5, upgrade_1_level))
		_update_label()
		_update_upgrade_1_level()


func _on_ClickButton_pressed() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("ShakeClick")
	score += 1 + upgrade_1_level
	_update_label()
	if not upgrade_1_shown and score >= 10:
		upgrade_1_shown = true
		upgrade_button_1.visible = true
		upgrade_label_1.visible = true


func _update_label() -> void:
	score_label.text = str(score)


func _update_upgrade_1_level() -> void:
	upgrade_label_1.text = "Level " + str(upgrade_1_level) + " (Next: " + str(int(upgrade_1_cost)) + ")"
