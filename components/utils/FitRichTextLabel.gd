class_name FitRichTextLabel
extends RichTextLabel

@export var min_font_size: int = 8
@export var max_font_size: int = 32

func _ready() -> void:
	fit_content = false
	scroll_active = false
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	resized.connect(fit_text)
	fit_text.call_deferred()

func set_fitted_text(value: String, min_size: int = min_font_size, max_size: int = max_font_size) -> void:
	text = value
	min_font_size = min_size
	max_font_size = max_size
	
	fit_text.call_deferred()

func fit_text() -> void:
	for font_size: int in range(max_font_size, min_font_size - 1, -1):
		_apply_font_size(font_size)
		if get_content_height() <= int(size.y):
			return
	_apply_font_size(min_font_size)

func _apply_font_size(font_size: int) -> void:
	for type_name: String in ["normal_font_size", "bold_font_size", "italics_font_size", "bold_italics_font_size"]:
		add_theme_font_size_override(type_name, font_size)
