extends CanvasLayer

@onready var animation_player = $AnimationPlayer

var scene_nodes: Array[Node] = []

func _ready() -> void:
  hide()

func forward():
  show()
  animation_player.play("SceneChange")
  await animation_player.animation_finished

func backward():
  animation_player.play_backwards("SceneChange")
  await animation_player.animation_finished
  hide()

func pop_to_root_scene():
  await forward()
  while len(scene_nodes) > 1:
    var last_scene: Node = scene_nodes.pop_back()
    get_tree().root.remove_child.call_deferred(last_scene)
    last_scene.queue_free()
  await backward()
  #get_tree().root.print_tree_pretty()

func next_scene(scene: Node):
  await forward()
  scene_nodes.append(scene)
  get_tree().root.add_child.call_deferred(scene)
  await backward()
  #get_tree().root.print_tree_pretty()

func back_scene():
  var last_scene: Node = scene_nodes.pop_back()
  if last_scene != null:
    await forward()
    get_tree().root.remove_child.call_deferred(last_scene)
    last_scene.queue_free()
    await backward()
  #get_tree().root.print_tree_pretty()
