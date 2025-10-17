extends Control

var score: int = 999
var score_total: int = 999
var money: int = 0
var next_money_gain: float = 1000
var money_level: int = 0
var upgrade_1_level: int = 0
var upgrade_1_cost: int = 10
var upgrade_1_shown: bool = false
var upgrade_2_level: int = 0
var upgrade_2_cost: int = 100
var upgrade_2_shown: bool = false
var time_accumulator = 0.0



@onready var click_button: Button = $CenterContainer/VBoxContainer/ClickButton
@onready var score_label: Label = $CenterContainer/VBoxContainer/ScoreLabel
@onready var upgrade_button_1: Button = $UpgradeContainer1/UpgradeButton1
@onready var upgrade_label_1: Label = $UpgradeContainer1/UpgradeLabel1
@onready var upgrade_button_2: Button = $UpgradeContainer2/UpgradeButton2
@onready var upgrade_label_2: Label = $UpgradeContainer2/UpgradeLabel2
@onready var hitmarker_template = $HitMarker
@onready var info_logo1 = $Info
@onready var info_1 = $Info/Area2D
@onready var info_label = $Info/InfoLabel
@onready var info_logo2 = $Info2
@onready var info_2 = $Info2/Area2D
@onready var info_label2 = $Info2/InfoLabel2
@onready var stat_button = $StatsGroup/StatButton
@onready var stat_group = $StatsGroup
@onready var stat_click_label = $StatsGroup/VBoxContainer/Stat_click
@onready var stat_click_label2 = $StatsGroup/VBoxContainer/Stat_click2
@onready var money_count = $MoneyCount
@onready var skills_button = $SkillsGroup/SkillsButton
@onready var skills_group = $SkillsGroup
@onready var skill_stats_button = $SkillsGroup/VBoxContainer/SkillStatsButton



func _ready() -> void:
	click_button.pressed.connect(_on_ClickButton_pressed)
	upgrade_button_1.pressed.connect(_on_UpgradeButton1_pressed)
	upgrade_button_2.pressed.connect(_on_UpgradeButton2_pressed)
	info_1.mouse_entered.connect(_on_Info_1_entered)
	info_1.mouse_exited.connect(_on_Info_1_exited)
	info_2.mouse_entered.connect(_on_Info_2_entered)
	info_2.mouse_exited.connect(_on_Info_2_exited)
	stat_button.pressed.connect(_on_StatButton_pressed)
	skills_button.pressed.connect(_on_SkillsButton_pressed)
	skill_stats_button.pressed.connect(_onSkillStatsButton_pressed)
	_update_score_label()
	_update_upgrade_1_level()
	upgrade_button_1.visible = false
	upgrade_label_1.visible = false
	upgrade_button_2.visible = false
	upgrade_label_2.visible = false
	info_logo1.visible = false
	info_label.visible = false
	info_logo2.visible = false
	info_label2.visible = false
	stat_click_label.visible = false
	stat_click_label2.visible = false
	stat_button.visible = false
	money_count.visible = false
	skills_button.visible = false


func _process(delta):
	upgrade_button_1.disabled = score < upgrade_1_cost
	upgrade_button_2.disabled = score < upgrade_2_cost
	if is_instance_valid(skill_stats_button):
		skill_stats_button.disabled = money < 1
	time_accumulator += delta
	if time_accumulator >= 1.0:
		score += upgrade_2_level
		score_total += upgrade_2_level
		time_accumulator = 0.0
		_check_score()
		_update_score_label()


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


func _on_Info_1_entered() -> void:
	info_label.visible = true
	info_label.position = get_global_mouse_position() - info_label.size


func _on_Info_1_exited() -> void:
	info_label.visible = false
	
	
func _on_Info_2_entered() -> void:
	info_label2.visible = true
	info_label2.position = get_global_mouse_position() - info_label.size - Vector2(0, 100)


func _on_Info_2_exited() -> void:
	info_label2.visible = false


func _on_UpgradeButton1_pressed() -> void:
	if score >= upgrade_1_cost:
		score -= upgrade_1_cost
		upgrade_1_level += 1
		upgrade_1_cost = int(10 * pow(1.5, upgrade_1_level))
		_update_score_label()
		_update_upgrade_1_level()
		_update_stat_click()
		
	if upgrade_1_level > 0 and not stat_click_label.visible:
		stat_click_label.visible = true


func _on_UpgradeButton2_pressed():
	if score >= upgrade_2_cost:
		score -= upgrade_2_cost
		upgrade_2_level += 1
		upgrade_2_cost = int(100 * pow(1.5, upgrade_2_level))
		_update_score_label()
		_update_upgrade_2_level()
		_update_stat_click2()
	
	if upgrade_2_level > 1 and not stat_click_label2.visible:
		stat_click_label2.visible = true
		


func _on_ClickButton_pressed() -> void:
	_spawn_hitmarker()
	$AnimationPlayer.stop()
	$AnimationPlayer.play("ShakeClick")
	score += 1 + upgrade_1_level
	score_total += 1 + upgrade_1_level
	_check_score()
	_update_score_label()
	if not upgrade_1_shown and score >= 10:
		upgrade_1_shown = true
		upgrade_button_1.visible = true
		upgrade_label_1.visible = true
		info_logo1.visible = true
	if not upgrade_2_shown and score >= 100:
		upgrade_1_shown = true
		upgrade_button_2.visible = true
		upgrade_label_2.visible = true
		info_logo2.visible = true
		

func _on_StatButton_pressed():
	var tween = create_tween()
	if stat_group.position.x == 0:
		tween.tween_property(stat_group, "position:x", -227, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		stat_button.text = str(">>>\nStats\n>>>")
	else:
		tween.tween_property(stat_group, "position:x", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		stat_button.text = str("<<<\nStats\n<<<")
		

func _on_SkillsButton_pressed():
	var tween = create_tween()
	if skills_group.position.x == 0:
		tween.tween_property(skills_group, "position:x", -227, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		skills_button.text = str(">>>\nSkills\n>>>")
	else:
		tween.tween_property(skills_group, "position:x", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		skills_button.text = str("<<<\nSkills\n<<<")
	


func _update_score_label() -> void:
	score_label.text = str(score)


func _update_upgrade_1_level() -> void:
	upgrade_label_1.text = "Level " + str(upgrade_1_level) + " (Next: " + str(int(upgrade_1_cost)) + ")"
	
	
func _update_upgrade_2_level():
	upgrade_label_2.text = "Level " + str(upgrade_2_level) + " (Next: " + str(int(upgrade_2_cost)) + ")"
		
	
func _update_stat_click():
	stat_click_label.text = str(upgrade_1_level + 1) + " Clicks / Click"
	
	
func _update_stat_click2():
	stat_click_label2.text = str(upgrade_2_level) + " Clicks / Second"

func _check_score():
	if score_total >= 1000 and not money_count.visible:
		money_count.visible = true
		skills_button.visible = true
		
	while score_total >= next_money_gain:
		money += 1
		money_count.text = str(money) + " $"
		next_money_gain *= 2

func _onSkillStatsButton_pressed():
	stat_button.visible = true
	skill_stats_button.queue_free()
