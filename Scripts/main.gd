extends Node

@export var main_scene_tscn: PackedScene

func _on_ready() -> void:
  var current_scene = main_scene_tscn.instantiate()
  SceneChanger.next_scene(current_scene)
