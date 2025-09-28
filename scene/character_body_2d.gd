extends CharacterBody2D

# --- Movement constants ---
const SPEED = 200.0
const JUMP_VELOCITY = -300.0

# --- Node references ---
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $"../CanvasLayer/Control/HBoxContainer/VBoxContainer/HB_Bar_P1"

# --- Health + Spawn ---
@export var max_health: int = 100
var health: int
@export var spawn_point: NodePath  # set this to "SpawnP1" in the Inspector

# --- Invincibility ---
var invincible: bool = false
var invincibility_time: float = 1.5  # seconds

func _ready() -> void:
	# Initialize health
	health = max_health
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = health

# --- Movement ---
func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump (W)
	if Input.is_action_just_pressed("jump_p1") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Move (A / D)
	var direction := Input.get_axis("move_left_p1", "move_right_p1")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 10)

	move_and_slide()

	# Flip sprite
	sprite_2d.flip_h = velocity.x < 0


# --- Damage Handling ---
func take_damage(amount: int) -> void:
	if invincible:
		return  # Ignore damage if invincible

	health -= amount
	print("Player1 health:", health)

	# Update health bar
	if health_bar:
		health_bar.value = max(health, 0)

	# Flash red effect
	flash_red()

	# Death check
	if health <= 0:
		die()


func flash_red() -> void:
	if sprite_2d:
		sprite_2d.modulate = Color(1, 0, 0)  # red
		var timer := get_tree().create_timer(0.2)
		timer.timeout.connect(func():
			if sprite_2d:
				sprite_2d.modulate = Color(1, 1, 1))  # back to normal


# --- Death + Respawn ---
func die() -> void:
	print("Player1 died, respawning...")

	# Reset health
	health = max_health
	if health_bar:
		health_bar.value = health

	# Respawn at spawn point
	if spawn_point != null:
		var spawn_node = get_node(spawn_point)
		if spawn_node:
			global_position = spawn_node.global_position

	# Enable temporary invincibility after respawn
	become_invincible()


# --- Invincibility ---
func become_invincible() -> void:
	invincible = true
	sprite_2d.modulate = Color(1, 1, 1, 0.5)  # semi-transparent effect

	var timer := get_tree().create_timer(invincibility_time)
	timer.timeout.connect(func():
		invincible = false
		sprite_2d.modulate = Color(1, 1, 1))  # reset to normal
