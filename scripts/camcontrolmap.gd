extends TextureRect

var current_camera : String = "CAM1A"
var active_sprite : AnimatedSprite2D = null 

@onready var bonnie = $"../../BonnieAI"
@onready var chica = $"../../ChicaAI"
@onready var freddy = $"../../FreddyAI"

func _ready() -> void:
	$CAM1A.input_event.connect(CAM1A)
	$CAM1B.input_event.connect(CAM1B)
	$CAM5.input_event.connect(CAM5)
	$CAM1C.input_event.connect(CAM1C)
	$CAM2A.input_event.connect(CAM2A)
	$CAM2B.input_event.connect(CAM2B)
	$CAM3.input_event.connect(CAM3)
	$CAM7.input_event.connect(CAM7)
	$CAM4A.input_event.connect(CAM4A)
	$CAM4B.input_event.connect(CAM4B)
	$CAM6.input_event.connect(CAM6)
	
func CAM1A(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM1A"
			update_camera_view("CAM1A")
			
func CAM1B(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM1B"
			update_camera_view("CAM1B")
			
func CAM5(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM5"
			update_camera_view("CAM5")
			
func CAM1C(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM1C"
			update_camera_view("CAM1C")
			
func CAM2A(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM2A"
			update_camera_view("CAM2A")

func CAM2B(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM2B"
			update_camera_view("CAM2B")
			
func CAM3(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM3"
			update_camera_view("CAM3")

func CAM7(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM7"
			update_camera_view("CAM7")

func CAM4A(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM4A"
			update_camera_view("CAM4A")
			
func CAM4B(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM4B"
			update_camera_view("CAM4B")
			
func CAM6(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("guiclick"):
		if name == "map":
			whiteblip()
			current_camera = "CAM6"
			update_camera_view("CAM6")

func update_camera_view(cam_name: String) -> void:
	#print("Checking camera: ", cam_name)
	
	if active_sprite != null:
		active_sprite.visible = false
		if active_sprite == $"../../kitchen":
			$"../kitchentext".visible = false
		$"../../easthallcorneranimation".visible = false
		
	match cam_name:
		"CAM1A": # Show Stage
			active_sprite = $"../../ShowStage"
			var b_here = (bonnie.current_state == bonnie.State.SHOW_STAGE)
			var c_here = (chica.current_state == chica.State.SHOW_STAGE)
			var f_here = (freddy.current_state == freddy.State.SHOW_STAGE)
			
			if b_here and c_here and f_here:
				active_sprite.frame = [0, 1].pick_random()
			elif b_here and f_here:
				active_sprite.frame = 3 
			elif c_here and f_here:
				active_sprite.frame = 2
			elif f_here :
				active_sprite.frame = [4, 5].pick_random()
			else :
				active_sprite.frame = 6

		"CAM1B": # Dining Area
			active_sprite = $"../../DiningHall"
			var b_here = (bonnie.current_state == bonnie.State.DINING_AREA)
			var c_here = (chica.current_state == chica.State.DINING_AREA)
			var f_here = (freddy.current_state == freddy.State.DINING_AREA)
			
			if b_here:
				active_sprite.frame = randi_range(1, 2)
			elif c_here:
				active_sprite.frame = randi_range(3, 4)
			elif f_here:
				active_sprite.frame = 5
			else:
				active_sprite.frame = 0
				
		"CAM5": 
			active_sprite = $"../../BackStage"
			var b_here = (bonnie.current_state == bonnie.State.BACKSTAGE)
			if b_here:
				active_sprite.frame = [1, 3].pick_random()
			else:
				active_sprite.frame = [0, 2].pick_random()
				
		"CAM1C": 
			active_sprite = $"../../PirateCove"
			
		"CAM2A": 
			active_sprite = $"../../WestHall"
			var b_here = (bonnie.current_state == bonnie.State.WEST_HALL)
			if b_here:
				active_sprite.frame = 2
			else:
				active_sprite.frame = [0, 1].pick_random()
				
		"CAM2B": 
			active_sprite = $"../../WHallCorner"
			var b_here = (bonnie.current_state == bonnie.State.WEST_HALL_CORNER)
			if b_here:
				active_sprite.frame = [1, 2, 3].pick_random()
			else:
				active_sprite.frame = [0, 4, 5].pick_random()
			
		"CAM3": 
			active_sprite = $"../../SupplyCloset"
			var b_here = (bonnie.current_state == bonnie.State.SUPPLY_CLOSET)
			if b_here:
				active_sprite.frame = 1
			else:
				active_sprite.frame = 0
		
		"CAM7": 
			active_sprite = $"../../restroom"
			var c_here = (chica.current_state == chica.State.RESTROOMS)
			var f_here = (freddy.current_state == freddy.State.RESTROOMS)
			
			if c_here:
				active_sprite.frame = [1, 2].pick_random()
			elif f_here:
				active_sprite.frame = 3
			else:
				active_sprite.frame = 0
				
		"CAM4A": 
			active_sprite = $"../../easthall"
			var c_here = (chica.current_state == chica.State.EAST_HALL)
			var f_here = (freddy.current_state == freddy.State.EAST_HALL)
			if c_here:
				active_sprite.frame = [1, 2].pick_random()
			elif f_here:
				active_sprite.frame = 3
			else:
				active_sprite.frame = [0, 4, 5].pick_random()
				
		"CAM4B": 
			active_sprite = $"../../easthallcorner"
			var c_here = (chica.current_state == chica.State.EAST_HALL_CORNER)
			var f_here = (freddy.current_state == freddy.State.EAST_HALL_CORNER)
			if c_here:
				$"../../easthallcorneranimation".visible = true
			elif f_here:
				active_sprite.frame = 4
			else:
				active_sprite.frame = [0, 5, 6, 7, 8].pick_random()
				
		"CAM6": 
			active_sprite = $"../../kitchen"
			$"../kitchentext".visible = true
			var c_here = (chica.current_state == chica.State.KITCHEN)
			if c_here:
				pass
			else:
				pass
			
	if active_sprite != null:
		active_sprite.visible = true

func whiteblip() -> void:
	$"../whiteblip".visible = true
	$"../whiteblip".play()
	$"../whiterect/blip".play()
	await get_tree().create_timer(0.25).timeout
	$"../whiteblip".stop()
	$"../whiteblip".visible = false
