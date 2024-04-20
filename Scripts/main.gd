extends Node

@export var main_scene_tscn: PackedScene

var current_scene: Node = null

func _on_ready() -> void:
  current_scene = main_scene_tscn.instantiate()
  add_child(current_scene)

func change_scene(scene: Node):
  current_scene.queue_free()
  current_scene = scene
  add_child(current_scene)
