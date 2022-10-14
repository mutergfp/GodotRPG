extends CharacterBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _alea : RandomNumberGenerator
@export var _max_speed: int 
@export var _friction: int
@export var _acceleration: int 
var _velocity : Vector2
var _sprite : AnimatedSprite2D
var _navigationAgent : NavigationAgent2D
var _initialPosition
var _realInitialPosition
var _direction : Vector2

@export var _minSecResetMoving: int
@export var _maxSecResetMoving: int
var _resetMoving : Timer


var _isChasing : bool
var _isGoingBackToPosition : bool
	
var _player

const EPSILON = 0.01

@export var _distance: float

# Called when the node enters the scene tree for the first time.
func _ready():
	_alea = RandomNumberGenerator.new()
	_sprite = $BatAnimatedSprite
	_navigationAgent = $NavigationAgent2D
	_sprite.play("fly")
	_player = null
	_isChasing = false
	_isGoingBackToPosition = false
	_initialPosition = global_position
	_realInitialPosition = global_position
	_direction = Vector2.ZERO
	_resetMoving = $ResetMoving
	_resetMoving.stop()
	
	

	
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_alea.randomize()
	
	if _player:
		_navigationAgent.set_target_location(_player.global_position)
		_direction = global_position.direction_to(_navigationAgent.get_next_location())
	elif _isChasing && !_player:
		print("Backing")
		if((_initialPosition - global_position) > Vector2(EPSILON,EPSILON)):
			_isChasing = false
	elif _resetMoving.is_stopped() :
		print("TimerStarted")
		_resetMoving.start(_alea.randf_range(_minSecResetMoving,_maxSecResetMoving))
		_navigationAgent.set_target_location(Vector2(_alea.randf_range(-100,100),_alea.randf_range(-100,100)))
		_direction = global_position.direction_to(_navigationAgent.get_next_location())
	else : 	
		_initialPosition = global_position
		
	_velocity = _velocity.move_toward(_direction * _max_speed, _acceleration * delta)
	
	_sprite.flip_h = _velocity.x < 0
	
	set_velocity(_velocity)
	move_and_slide()

func _on_DetectArea_body_entered(body):
	if(body.get_class() == "Player"):
		_player = body
		_navigationAgent.set_target_location(_player.global_position)
		_resetMoving.stop()
		_isChasing = true
		print("TimerStOPPED")
		


func _on_FollowArea_body_exited(body):
	if(body.get_class() == "Player"):
		_player = null
		_navigationAgent.set_target_location(_initialPosition)
		_direction = global_position.direction_to(_navigationAgent.get_next_location())

func _on_Hitbox_child_entered_tree(entity):
	pass
	#if entity.instanceof Player



func _on_ResetMoving_timeout():
	_resetMoving.stop()
	print("TimerStOPPED")
