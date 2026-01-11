extends Camera2D

var screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width")

@export var scrollArea : int
@export var scrollSpeed : float
@export var scrollDivisions : int
@export var officeSprite : AnimatedSprite2D

var officeWidth : int
var distance : float
var divisionSize : float
var speedMultiplier : float

func _ready() -> void:
	if scrollDivisions == 0:
		scrollDivisions = 1
	divisionSize = scrollArea / scrollDivisions
	if officeSprite:
		var current_anim = officeSprite.animation
		var tex = officeSprite.sprite_frames.get_frame_texture(current_anim, 0)
		officeWidth = tex.get_width()
		position.x = (officeWidth - screenWidth) / 2

func _process(delta: float) -> void:
	if get_local_mouse_position().x < scrollArea:
		distance = scrollArea - get_local_mouse_position().x
		getSpeedMultiplier()
		position.x -= (scrollSpeed * speedMultiplier) * delta
	if get_local_mouse_position().x > screenWidth - scrollArea:
		distance = get_local_mouse_position().x - (screenWidth - scrollArea)
		getSpeedMultiplier()
		position.x += (scrollSpeed * speedMultiplier) * delta
	
	if officeSprite:
		if position.x < officeSprite.position.x:
			position.x = officeSprite.position.x
		if position.x + screenWidth > officeWidth:
			position.x = officeWidth - screenWidth
			
func getSpeedMultiplier() -> void:
	speedMultiplier = clamp(floor(distance / divisionSize) + 1, 1, scrollDivisions)
	speedMultiplier /= scrollDivisions
	
func lock_to_center() -> void:
	set_process(false)
	var target_x = (officeWidth - screenWidth) / 2
	#print(target_x)
	var tween = create_tween()
	tween.tween_property(self, "position:x", target_x, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
func lock_to_right() -> void:
	set_process(false)
	var target_x = (officeWidth - screenWidth) / 2 + 150
	#print(target_x)
	var tween = create_tween()
	tween.tween_property(self, "position:x", target_x, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
