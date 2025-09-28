extends Area2D

@export var damage: int = 10                 # Damage per tick
@export var damage_interval: float = 0.5     # Time between damage ticks (seconds)

var players_in_area: Array = []


func _ready() -> void:
	# Connect signals
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("players"):  # Make sure both Player1 & Player2 are in the "players" group
		if body not in players_in_area:
			players_in_area.append(body)
			apply_damage(body)  # Start damaging this body


func _on_body_exited(body: Node) -> void:
	if body in players_in_area:
		players_in_area.erase(body)


func apply_damage(body: Node) -> void:
	# Only apply damage if still inside lava
	if body in players_in_area and body.has_method("take_damage"):
		# Respect invincibility (skip if invincible)
		if not body.invincible:
			body.take_damage(damage)

		# Keep applying damage on interval
		var timer := get_tree().create_timer(damage_interval)
		timer.timeout.connect(func():
			apply_damage(body))
