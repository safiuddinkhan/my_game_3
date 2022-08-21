extends KinematicBody2D
export var obstacle_radius:float = 32


func _ready():
	Navigation2DServer.agent_set_map($NavigationObstacle2D.get_rid(), get_world_2d().get_navigation_map())
	Navigation2DServer.agent_set_radius($NavigationObstacle2D.get_rid(), obstacle_radius)


func _process(_delta):
	pass
