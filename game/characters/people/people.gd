extends CharacterBody2D


const SPEED = 220.0
const MOAN_FREQUENCY_MIN = 8.0
const MOAN_FREQUENCY_MAX = 16.0

@export var human_variations: Array[Texture2D]
@export var zombie_variations: Array[Texture2D]

## Looking direction
@export_enum("Left", "Right", "Up", "Down") var direction: int = 3

## Text that is displayed when interacted with
@export_multiline var dialog: String

var player: Player
var zombie: bool = false
var alert: bool = false

var variant: int


func _ready() -> void:
	variant = randi() % human_variations.size()
	%Sprite.texture = human_variations[variant]
	
	look_in_default_direction()
		
	
	Events.present_started.connect(on_present_started)


func _physics_process(delta: float) -> void:
	if player == null:
		return
	
	if not zombie or not alert:
		return
	
	# chase player
	var direction_to_player := position.direction_to(player.position)
	velocity = direction_to_player * SPEED
	move_and_slide()
	
	# animation
	play_animation_based_on_direction(direction_to_player, "walk")


func interact() -> void:
	if zombie:
		return
	
	if dialog.length() > 0:
		play_animation_based_on_direction(position.direction_to(player.position), "idle")
		%DialogBubble.show_text(dialog)
		%DialogTimer.start()




func look_in_default_direction() -> void:
	match direction:
		0: # left
			%AnimationPlayer.play("idle_left")
		1: # right
			%AnimationPlayer.play("idle_right")
		2: # up
			%AnimationPlayer.play("idle_up")
		3: # down
			%AnimationPlayer.play("idle_down")


func play_animation_based_on_direction(_direction: Vector2, animation: String) -> void:
	match _direction.snapped(Vector2.ONE):
		Vector2.LEFT:
			%AnimationPlayer.play(animation + "_left")
		Vector2.RIGHT:
			%AnimationPlayer.play(animation + "_right")
		Vector2.UP:
			%AnimationPlayer.play(animation + "_up")
		Vector2.DOWN:
			%AnimationPlayer.play(animation + "_down")


func on_present_started() -> void:
	%Sprite.texture = zombie_variations[variant]
	zombie = true
	%MoanTimer.start(randf_range(0.0, MOAN_FREQUENCY_MAX))


func _on_moan_timer_timeout() -> void:
	%snd_moan.play()
	%MoanTimer.start(randf_range(MOAN_FREQUENCY_MIN, MOAN_FREQUENCY_MAX))


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		alert = true


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body is Player:
		alert = false


func _on_dialog_timer_timeout() -> void:
	%DialogBubble.hide_text()
	look_in_default_direction()


func _on_death_detector_body_entered(body: Node2D) -> void:
	if zombie and body is Player:
		Events.player_died.emit()
