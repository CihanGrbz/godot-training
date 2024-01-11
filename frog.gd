extends CharacterBody2D

const SPEED = 75.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player 
var chase = false

@onready var anim = get_node("AnimatedSprite2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../Player/Player")
	anim.play("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if anim.animation != "Death":
		if chase:
			var direction = (player.position - self.position).normalized()
			velocity.x = direction.x * SPEED
			anim.play("Jump")
			
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = true
			elif direction.x < 0:
				get_node("AnimatedSprite2D").flip_h = false
			
		else:
			velocity.x = 0
			anim.play("Idle")
	
	move_and_slide()

func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		


func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false


func _on_player_death_body_entered(body):
	if body.name == "Player":
		death()
		


func _on_player_collision_body_entered(body):
	if body.name == "Player":
		Game.playerHP -= 1
		death()

func death():
	Game.Gold += 1
	Utils.saveGame()
	chase = false
	anim.play("Death")
	await anim.animation_finished
	self.queue_free()
