extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ret_val

# Called when the node enters the scene tree for the first time.
func _ready():
	Navigation2DServer.agent_set_map($NavigationObstacle2D.get_rid(),get_world_2d().navigation_map)


func _physics_process(_delta):
	var direction = Vector2.ZERO
	ret_val = self.move_and_slide(direction)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if(collision.collider.name == "player_character"):
			ret_val = move_and_slide(collision.collider_velocity)

