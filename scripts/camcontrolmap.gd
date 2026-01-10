extends TextureRect

var current_camera : String = "CAM1A"
var active_sprite : AnimatedSprite2D = null 

@onready var bonnie = $"../../BonnieAI"

func _ready() -> void:
	$CAM1A.input_event.connect(CAM1A)
	$CAM1B.input_event.connect(CAM1B)
	$CAM5.input_event.connect(CAM5)
	$CAM1C.input_event.connect(CAM1C)
	$CAM2A.input_event.connect(CAM2A)
	$CAM2B.input_event.connect(CAM2B)
	$CAM3.input_event.connect(CAM3)
	
func CAM1A(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			print("CHANGE MAP")
			whiteblip()
			current_camera = "CAM1A"
			update_camera_view("CAM1A")
			
func CAM1B(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			print("CHANGE MAP")
			whiteblip()
			current_camera = "CAM1B"
			update_camera_view("CAM1B")
			
func CAM5(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			print("CHANGE MAP")
			whiteblip()
			current_camera = "CAM5"
			update_camera_view("CAM5")
			
func CAM1C(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			print("CHANGE MAP")
			whiteblip()
			current_camera = "CAM1C"
			update_camera_view("CAM1C")
			
func CAM2A(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			print("CHANGE MAP")
			whiteblip()
			current_camera = "CAM2A"
			update_camera_view("CAM2A")

func CAM2B(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			print("CHANGE MAP")
			whiteblip()
			current_camera = "CAM2B"
			update_camera_view("CAM2B")
			
func CAM3(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			print("CHANGE MAP")
			whiteblip()
			current_camera = "CAM3"
			update_camera_view("CAM3")

func update_camera_view(cam_name: String) -> void:
	print("Checking camera: ", cam_name)
	
	if active_sprite != null:
		active_sprite.visible = false
	
	match cam_name:
		"CAM1A": # Show Stage
			active_sprite = $"../../ShowStage"
			var b_here = (bonnie.current_state == bonnie.State.SHOW_STAGE)
			if b_here:
				active_sprite.frame = 1
			else:
				print("MOVED")
				active_sprite.frame = 2 

		"CAM1B": # Dining Area
			active_sprite = $"../../DiningHall"
			var b_here = (bonnie.current_state == bonnie.State.DINING_AREA)
			if b_here:
				active_sprite.frame = randi_range(1, 2)
			else:
				print("MOVED")
				active_sprite.frame = 0
				
		"CAM5": 
			active_sprite = $"../../BackStage"
			var b_here = (bonnie.current_state == bonnie.State.BACKSTAGE)
			if b_here:
				active_sprite.frame = [1, 3].pick_random()
			else:
				print("MOVED")
				active_sprite.frame = [0, 2].pick_random()
				
		"CAM1C": 
			active_sprite = $"../../PirateCove"
			
		"CAM2A": 
			active_sprite = $"../../WestHall"
			var b_here = (bonnie.current_state == bonnie.State.WEST_HALL)
			if b_here:
				active_sprite.frame = 2
			else:
				print("MOVED")
				active_sprite.frame = [0, 1].pick_random()
				
		"CAM2B": 
			active_sprite = $"../../WHallCorner"
			var b_here = (bonnie.current_state == bonnie.State.WEST_HALL_CORNER)
			if b_here:
				active_sprite.frame = [1, 2, 3].pick_random()
			else:
				print("MOVED")
				active_sprite.frame = [0, 4, 5].pick_random()
			
		"CAM3": 
			active_sprite = $"../../SupplyCloset"
			var b_here = (bonnie.current_state == bonnie.State.SUPPLY_CLOSET)
			if b_here:
				active_sprite.frame = 1
			else:
				print("MOVED")
				active_sprite.frame = 0
		
			
	if active_sprite != null:
		active_sprite.visible = true

func whiteblip() -> void:
	$"../whiteblip".visible = true
	$"../whiteblip".play()
	$"../whiterect/blip".play()
	await get_tree().create_timer(0.25).timeout
	$"../whiteblip".stop()
	$"../whiteblip".visible = false
