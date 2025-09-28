extends Area2D

@export var damage: int = 25  # how much health to take away when touched

# This runs when something enters the lava's collision area
func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):  # only affect players
		if body.has_method("take_damage"):  # make sure player has this function
			body.take_damage(damage)
