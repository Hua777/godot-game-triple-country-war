extends Node

@export var master: bool:
  set(value):
    master = value
    if master:
      start_button.text = '开始游戏'
      loyal_count_editor.editable = true
      traitor_count_editor.editable = true
      rebel_count_editor.editable = true
    else:
      start_button.text = '准备'
      loyal_count_editor.editable = false
      traitor_count_editor.editable = false
      rebel_count_editor.editable = false

@onready var loyal_count_editor = $"房间表单/外包/堆叠/下层堆叠/Margin控制器/VBoxContainer/Grid身份设置/Editor忠臣数量"
@onready var traitor_count_editor = $"房间表单/外包/堆叠/下层堆叠/Margin控制器/VBoxContainer/Grid身份设置/Editor内奸数量"
@onready var rebel_count_editor = $"房间表单/外包/堆叠/下层堆叠/Margin控制器/VBoxContainer/Grid身份设置/Editor反贼数量"

@onready var start_button = $"房间表单/外包/堆叠/下层堆叠/Margin控制器/VBoxContainer/Button开始游戏"

@onready var grid_players = $"房间表单/外包/堆叠/下层堆叠/Grid玩家们"

var checked = false

func _on_ready() -> void:
  master = false
  for player_head in grid_players.get_children():
    print(player_head.index)

func _on_room_leave_button_pressed() -> void:
  SceneChanger.back_scene()

func _on_user_player_pressed(player_head) -> void:
  player_head.joined = true
  player_head.user_name = 'Hua777'

func _on_user_player_kick_out(player_head) -> void:
  player_head.joined = false

func _on_start_pressed() -> void:
  if master:
    pass
  else:
    if checked:
      start_button.text = '准备'
      checked = false
    else:
      start_button.text = '取消准备'
      checked = true
