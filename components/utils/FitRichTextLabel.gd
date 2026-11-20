## RichTextLabel that picks the largest font size (between min and max) that fits its box.
## Note: _ready() forces fit_content and scroll_active off and sets autowrap_mode to OFF,
## so Inspector values for those three are ignored.
## Set text with set_fitted_text() so it refits; resizes refit automatically.
class_name FitRichTextLabel
extends RichTextLabel

@export var min_font_size: int = 8
@export var max_font_size: int = 32

var _fitting: bool = false
var _refit_pending: bool = false

func _ready() -> void:
	fit_content = false
	scroll_active = false
	autowrap_mode = TextServer.AUTOWRAP_OFF
	fit_text.call_deferred()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		fit_text.call_deferred()

func fit_text() -> void:
	if _fitting:
		_refit_pending = true
		return
	if size.x <= 0 or size.y <= 0:
		return
	_fitting = true
	for font_size: int in range(max_font_size, min_font_size - 1, -1):
		_apply_font_size(font_size)
		
		if not is_finished():
			await finished
		if get_content_height() <= size.y and get_content_width() <= size.x:
			break
	_fitting = false
	if _refit_pending:
		_refit_pending = false
		fit_text.call_deferred()

func set_fitted_text(value: String, min_size: int = min_font_size, max_size: int = max_font_size) -> void:
	text = value
	min_font_size = min_size
	max_font_size = max_size
	
	fit_text.call_deferred()
	
func _apply_font_size(font_size: int) -> void:
	# Not used but kept close for future if needed : , "bold_font_size", "italics_font_size", "bold_italics_font_size"
	for type_name: String in ["normal_font_size"]:
		add_theme_font_size_override(type_name, font_size)
