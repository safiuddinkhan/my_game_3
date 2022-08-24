extends Node2D
var enemy_body

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("player_character"):
		print("player entered area")
		enemy_body = get_node_or_null("YSort/enemy_character")
		if enemy_body:
			enemy_body.walk = 0

	



func _on_Area2D_body_exited(body):
	if body.is_in_group("player_character"):
		print("player exited area")
		enemy_body = get_node_or_null("YSort/enemy_character")
		if enemy_body:
			enemy_body.walk = 1
