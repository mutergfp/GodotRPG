extends KinematicBody2D

export var speed : int

signal collision

var _animations : AnimatedSprite
var _velocity : Vector2
var _lastKeyPressed : String
var _isMoving : bool

func _ready():
	_animations = $AnimatedSprite
	_animations.play("StaticDown")
	
	
func _process(delta):
	_velocity = Vector2.ZERO
	
	handleInputs()
	
	changePosition(delta)

func handleInputs() :
	
	var isOppositeKeyPressedX = false
	var isOppositeKeyPressedY = false
	if(Input.is_action_pressed("Right") && Input.is_action_pressed("Left")):
		_velocity.x = 0
		isOppositeKeyPressedX = true
		
	if(Input.is_action_pressed("Up") && Input.is_action_pressed("Down")):
		_velocity.y = 0
		isOppositeKeyPressedY = true
		
	if(!isOppositeKeyPressedX):
		if Input.is_action_pressed("Right"):
			moveRight()
		if Input.is_action_pressed("Left"):
			moveLeft()
			
	if(!isOppositeKeyPressedY):
		if Input.is_action_pressed("Up"):
			moveUp()
		if Input.is_action_pressed("Down"):
			moveDown()
			

func moveLeft():
	_velocity.x = -1
	_lastKeyPressed = "Left"

func moveRight():
	_velocity.x = 1
	_lastKeyPressed = "Right"


func moveUp():
	_velocity.y = -1
	_lastKeyPressed = "Up"

func moveDown():
	_velocity.y = 1
	_lastKeyPressed = "Down"

func changePosition(delta):

	_velocity = _velocity * speed

	move_and_slide(_velocity)

	changeAnimation()

func changeAnimation():

	if(_velocity.y != 0):
		if(_velocity.y > 0):
			_animations.animation = "MoveDown"
		else:
			_animations.animation = "MoveUp"
	if(_velocity.x != 0):
		_animations.animation = "MoveSide"
		if(_velocity.x > 0):
			_animations.flip_h = true
		else:
			_animations.flip_h = false
			
	if(_velocity.y == 0 && _velocity.x == 0):
		match _lastKeyPressed:
			"Up":
				_animations.animation = "StaticUp"
			"Down":
				_animations.animation = "StaticDown"
			"Right", "Left":
				_animations.animation = "StaticSide"
				





