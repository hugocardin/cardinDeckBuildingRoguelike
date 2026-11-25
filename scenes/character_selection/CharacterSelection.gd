extends Node2D

const UI_THEME: Theme = preload("res://themes/ui_theme.tres")

@onready var v_box_container_reference: VBoxContainer = $VBoxContainer

func _ready() -> void:
	for character_name: String in CharacterDatabase.CHARACTERS:
		var button: Button = Button.new()
		button.theme = UI_THEME
		# TODO Use translation for names
		button.text = character_name.capitalize()
		button.pressed.connect(_on_character_selected.bind(character_name))
		v_box_container_reference.add_child(button)

func _on_character_selected(character_name: String) -> void:
	EventBus.character_selected.emit(character_name)
