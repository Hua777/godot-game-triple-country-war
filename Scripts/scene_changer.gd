extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
  hide()

func change_scene(scene):
  var main = get_tree().root.get_node("/root/Main")
  show()
  animation_player.play("SceneChange")
  await animation_player.animation_finished
  main.change_scene(scene)
  animation_player.play_backwards("SceneChange")
  await animation_player.animation_finished
  hide()
  get_tree().root.print_tree_pretty()
