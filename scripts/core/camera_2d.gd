extends Camera2D

var _previousPosition: Vector2 = Vector2(0, 0)
var _drag: bool = false
var _target_zoom: float = 1.0

const MAX_ZOOM: float = 2.0 
const MIN_ZOOM: float = 0.1
const ZOOM_INCREMENT: float = 0.1

const ZOOM_RATE: float = 10.0 

func _ready() -> void:
	_target_zoom = zoom.x

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and event.ctrl_pressed:
			_previousPosition = event.position
			_drag = true
		elif event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			_drag = false
		
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_out()
			
	elif event is InputEventMouseMotion and _drag:
		position += ((_previousPosition - event.position) / zoom)
		_previousPosition = event.position
		
func zoom_in():
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)

func zoom_out():
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, ZOOM_RATE * delta)
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))
