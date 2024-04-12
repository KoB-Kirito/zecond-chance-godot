class_name Player
extends CharacterBody2D


const SPEED = 200.0
const RUN_MULTIPLYER = 1.5

var is_dead: bool

@onready var sprite := %AnimatedSprite2D as AnimatedSprite2D


func _ready() -> void:
	Events.player_died.connect(on_player_died)


func on_player_died() -> void:
	is_dead = true
	#TODO: Death animation


func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		return
	
	# Movement
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	if Input.is_action_pressed("run"):
		velocity *= RUN_MULTIPLYER
	move_and_slide()


func _process(delta: float) -> void:
	# Animation
	if velocity.x > SPEED / 4:
		sprite.play("walk_right")
		
	elif velocity.x < -SPEED / 4:
		sprite.play("walk_left")
		
	elif velocity.y < 0:
		sprite.play("walk_up")
		
	elif velocity.y > 0:
		sprite.play("walk_down")
		
	else:
		# Play idle animation
		match sprite.animation:
			"walk_left":
				sprite.play("idle_left")
				
			"walk_up":
				sprite.play("idle_up")
				
			"walk_right":
				sprite.play("idle_right")
				
			"walk_down":
				sprite.play("idle_down")
