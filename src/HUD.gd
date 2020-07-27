extends CanvasLayer

signal start_game

onready var message = $Message
onready var message_timer = $MessageTimer

func show_message(text):
	message.text = text
	message.show()
	message_timer.start()
	
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
	
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
	emit_signal("start_game")
