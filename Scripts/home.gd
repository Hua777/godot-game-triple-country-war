extends Node

var room_tscn = preload("res://Scenes/room.tscn")

@onready var user_name_label = $"控制页/外包/MarginContainer/中间堆叠/名字"

@onready var room_search_editor = $"控制页/外包/左侧堆叠/Margin列表房间面板/Panal列表房间面板/Margin内列表房间面板/VBox列表房间面板/房间号搜索面板/Editor房间号"

@onready var room_create_id_editor = $"控制页/外包/右侧堆叠/Margin创建房间面板/Panal创建房间面板/Margin内创建房间面板/VBox创建房间面板/创建房间表单/Editor房间号"
@onready var room_create_password_editor = $"控制页/外包/右侧堆叠/Margin创建房间面板/Panal创建房间面板/Margin内创建房间面板/VBox创建房间面板/创建房间表单/Editor密码"

@onready var room_join_id_editor = $"控制页/外包/右侧堆叠/Margin加入房间面板/Panel加入房间面板/Margin内加入房间面板/VBox加入房间面板/加入房间表单/Editor房间号"
@onready var room_join_password_editor = $"控制页/外包/右侧堆叠/Margin加入房间面板/Panel加入房间面板/Margin内加入房间面板/VBox加入房间面板/加入房间表单/Editor密码"

func check_id_and_pwd(_id: String, pwd: String)->bool:
  if len(_id) < 4 or len(pwd) != 4:
    DialogTool.show_dialoig('请输入正确的房间号或密码', false)
    return false
  return true

func _on_ready() -> void:
  # TODO get user info
  user_name_label.text = Global.get_user_id()

func _on_room_search_button_pressed() -> void:
  pass # Replace with function body.

func _on_room_create_button_pressed() -> void:
  if check_id_and_pwd(room_create_id_editor.text, room_create_password_editor.text):
    var room = room_tscn.instantiate()
    SceneChanger.next_scene(room)

func _on_room_join_button_pressed() -> void:
  if check_id_and_pwd(room_join_id_editor.text, room_join_password_editor.text):
    var room = room_tscn.instantiate()
    SceneChanger.next_scene(room)

func _on_logout_button_pressed() -> void:
  SceneChanger.back_scene()
