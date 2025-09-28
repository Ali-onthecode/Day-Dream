extends CanvasLayer

@export var player1_path: NodePath
@export var player2_path: NodePath

@onready var player1 := get_node(player1_path)
@onready var player2 := get_node(player2_path)

@onready var hp_bar_p1: ProgressBar = $Control/HBoxContainer/VBoxContainer/HB_Bar_P1
@onready var hp_bar_p2: ProgressBar = $Control/HBoxContainer/VBoxContainer2/HB_Bar_P2

func _ready() -> void:
	if player1:
		hp_bar_p1.max_value = player1.max_health
		hp_bar_p1.value = player1.health
	if player2:
		hp_bar_p2.max_value = player2.max_health
		hp_bar_p2.value = player2.health

func _process(_delta: float) -> void:
	if player1:
		hp_bar_p1.value = clamp(player1.health, 0, player1.max_health)
	if player2:
		hp_bar_p2.value = clamp(player2.health, 0, player2.max_health)
