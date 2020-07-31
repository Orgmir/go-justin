extends CanvasLayer

signal start_game

export var player_shoot_timer = 1.0

onready var message = $Message
onready var message_timer = $MessageTimer

var player_can_shoot = false
var player_can_shoot_counter = 0.0


func _process(delta):
	player_can_shoot_counter += delta
	$BulletTimeBar.set_scale(Vector2(clamp(player_can_shoot_counter/player_shoot_timer, 0, 1), 1.0))


func show_message(text):
	message.text = text
	message.show()
	message_timer.start()
	
	
func update_score(score):
	$ScoreLabel.text = str(round(score))


func update_shoot_state(can_shoot: bool):
	if can_shoot != player_can_shoot and not can_shoot:
		player_can_shoot_counter = 0.0
	player_can_shoot = can_shoot
	
	
func show_game_over():
	show_message("Game over!")
	yield(message_timer, "timeout")
	
	message.text = "Try again, Justin!"
	message.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


func _on_MessageTimer_timeout():
	message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	$Controls.hide()
	emit_signal("start_game")
