extends "res://Classes/Character.gd"

const TYPE = "ENEMY"
var enemy_moves = {'up': Vector2(0,-1), 'right': Vector2(1,0), 'left': Vector2(-1,0), 'down': Vector2(0,1)}
const animation = "walk"

# For raycasting and figuring if player is seen
var sees_player = false
onready var player_target = get_parent().get_node("player")
var detect_radius = 300

# For handling how much time it talks to walk
var movetimer_length = 15
var movetimer = 0

func _ready():
	speed = 30
	randomize()
#	set_up_visibility_radius()

func _process(delta):
	character_movement()
	if sees_player: # pursues player if they see the player
		move_direction = (player_target.global_position - self.global_position).normalized()
		change_to_player_direction()
	else: # else do random movement
		if movetimer > 0:
			movetimer -= 1
		elif movetimer == 0:
			change_enemy_direction()
			movetimer = movetimer_length

#func set_up_visibility_radius():
#	var shape = CircleShape2D.new()
#	shape.radius = detect_radius
#	$Visibility/CollisionShape2D.shape = shape
	
#	#	Sets up signals for when enter area2D
#	get_node("Visibility").connect("body_entered", self, "on_Visibility_body_entered")
#	get_node("Visibility").connect("body_exited", self, "on_Visibility_body_exited")

func change_to_player_direction():
	if move_direction.x < 0:
		direction = 'left'
	elif move_direction.x > 0:
		direction = 'right'
		
	if move_direction.y < 0:
		direction = 'up'
	elif move_direction.y > 0:
		direction = 'down'
		
	enemy_animation()

func change_enemy_direction():
	var randNum = randi() % 4
	direction = enemy_moves.keys()[randNum]
	move_direction = enemy_moves.values()[randNum]
	enemy_animation()
	
func enemy_animation():
	var newanim = str(animation, direction)
	if $anim.current_animation != newanim:
		$anim.play(newanim)

func _on_Visibility_body_entered(body):
	var player_to_enemy_distance = (player_target.global_position - self.global_position).normalized()
#		sees_player = true


func _on_Visibility_body_exited(body):
	sees_player = false
