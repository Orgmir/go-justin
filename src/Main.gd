extends Node2D

export (PackedScene) var Enemy
var score


func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("enemies", "queue_free")
	

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")


func _on_EnemyTimer_timeout():
	$EnemyPath/EnemySpawnLocation.offset = randi()
	
	var enemy = Enemy.instance()
	add_child(enemy)
	
	enemy.position = $EnemyPath/EnemySpawnLocation.position
	var direction = PI
	direction += rand_range(-PI / 8, PI / 8)
	enemy.rotation = direction + PI
	
	enemy.linear_velocity = Vector2(rand_range(enemy.min_speed, enemy.max_speed), 0)
	enemy.linear_velocity = enemy.linear_velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()



