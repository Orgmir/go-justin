extends RigidBody2D

export var min_speed = 150
export var max_speed = 250
export var textures = []


func _ready():
	var texture = textures[randi() % textures.size()]
	$Sprite.texture = texture


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Enemy_body_entered(body):
	print(body)


func _on_Enemy_body_shape_entered(body_id, body, body_shape, local_shape):
	print(body)
