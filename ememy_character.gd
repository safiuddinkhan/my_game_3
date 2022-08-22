extends KinematicBody2D

export var speed = 40
var screen_size = Vector2.ZERO
var direction = Vector2.ZERO
var player_character
var ret_vel
var state = 0
var line2d
var char_ang
var nav_path
var label
var label3
var req_state
var new_state

#var frame_count = 0



func _ready():
	screen_size = get_viewport_rect().size
	var tree = get_tree()
	player_character = tree.get_nodes_in_group("player_character")[0]
	line2d = tree.get_nodes_in_group("line2d")[0]
	label = tree.get_nodes_in_group("label1")[0]
	label3 = tree.get_nodes_in_group("label3")[0]
	state = 0
	req_state = 0
	new_state = 0

#	$NavigationAgent2D.path_max_distance = 1

func navigate():
	var player_pos = player_character.global_position
	var next_location
	nav_path = Navigation2DServer.map_get_path($NavigationAgent2D.get_navigation_map(),global_position,player_pos,true)
	$NavigationAgent2D.set_target_location(player_pos)
	next_location = $NavigationAgent2D.get_next_location()
	direction = global_position.direction_to(next_location)
	var pos1 = next_location - global_position
	var curr_path = [Vector2.ZERO,pos1]
	line2d.points = curr_path


func _physics_process(_delta):

#	if frame_count == 0:
#		update_pc_location()

	var sprite_dir


	if state == 0:
		navigate()
		char_ang = rad2deg(direction.angle())
#		$Area2D.rotation_degrees = char_ang
		sprite_dir = int(char_ang / 60.0)
#		print("sprite_dir:", char_ang / 60.0," rounded:", sprite_dir, " raw ang:",rad2deg(direction.angle()))
		label.text = "frame animation:\""+$AnimatedSprite.animation+"\" frame_count:"+str($AnimatedSprite.frame)+" state_req_reg: "+str(req_state)+" curr state:"+str(state)
		label3.text = "dir:"+str(direction)
		if abs(sprite_dir) >= 2:
			$AnimatedSprite.play("walk_left")
		elif abs(sprite_dir) == 0:
			$AnimatedSprite.play("walk_right")
		elif sprite_dir == 1:
			$AnimatedSprite.play("walk_down")
		elif sprite_dir == -1:
			$AnimatedSprite.play("walk_up")
		ret_vel = self.move_and_slide(direction * speed)
	elif state == 1:
		var body_ang
#		direction = global_position.direction_to(player_character.global_position)
		body_ang = rad2deg(direction.angle())
#		$Area2D.rotation_degrees = body_ang
		sprite_dir = int(body_ang / 60.0)
		label.text = "frame animation:\""+$AnimatedSprite.animation+"\" frame_count:"+str($AnimatedSprite.frame)+" state_req_reg: "+str(req_state)+" curr state:"+str(state)
		if abs(sprite_dir) >= 2:
			$AnimatedSprite.play("attack_left")
		elif abs(sprite_dir) == 0:
			$AnimatedSprite.play("attack_right")
		elif sprite_dir == 1:
			$AnimatedSprite.play("attack_down")
		elif sprite_dir == -1:
			$AnimatedSprite.play("attack_up")
	

#		frame_count = frame_count + 1




#	if state == 0:
#		ret_vel = self.move_and_slide(direction*speed)












func _on_NavigationAgent2D_navigation_finished():
	state = 1
	#$AnimatedSprite.stop()



func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	ret_vel = self.move_and_slide(safe_velocity)
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
#		print("I collided with ", collision.collider.name)
#		if(collision.collider.name == "player_character"):
#			state = 0




func _on_NavigationAgent2D_path_changed():
	state = 0






func _on_Area2D_body_exited(body):
	print("body exited:",body.name)
	if(body.name == "player_character"):
		req_state = 1
		new_state = 0
#		$CollisionShape2D.shape.extents = Vector2(10, 4)
#		state = 0



func _on_Area2D_body_entered(body):
	print("body entered:",body.name)
	if(body.name == "player_character"):
		req_state = 1
		new_state = 1
#		$CollisionShape2D.shape.extents = Vector2(24, 4)





func _on_Area2D_mouse_entered():
	if state == 1:
		print("Hello Mouse Entered")



func _on_AnimatedSprite_animation_finished():
	if req_state == 1:
		print("State change requested. Changing to State ",new_state)
		req_state = 0
		state = new_state
#	pass






