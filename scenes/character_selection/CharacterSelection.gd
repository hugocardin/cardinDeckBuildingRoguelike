extends Node2D

const UI_THEME: Theme = preload("res://themes/ui_theme.tres")

var v_box_container_reference: VBoxContainer

func _ready() -> void:
	v_box_container_reference = $VBoxContainer

	for character_name: String in CharacterDatabase.CHARACTERS:
		var button: Button = Button.new()
		button.theme = UI_THEME
		button.text = character_name.capitalize()
		button.pressed.connect(_on_character_selected.bind(character_name))
		v_box_container_reference.add_child(button)

func _on_character_selected(character_name: String) -> void:
	EventBus.character_selected.emit(character_name)
