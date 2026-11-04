class_name Card

extends Node2D

signal hovered
signal hovered_off

var starting_position
var attack_text_reference
var health_text_reference

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)
	attack_text_reference = $Attack
	health_text_reference = $Health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
	
func setup(card_id, attributes):
	attack_text_reference.text = str(attributes["attack"])
	health_text_reference.text = str(attributes["health"])
	
	var image_path = "res://assets/cards/" + card_id + ".jpg"
	$CardImage.texture = load(image_path)
