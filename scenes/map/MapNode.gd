class_name MapNode
extends RefCounted

var type: Constants.LevelType
var id: int
var row: int
var col: int
var next: Array[int] = []

func _init() -> void:
	next = [] as Array[int]
