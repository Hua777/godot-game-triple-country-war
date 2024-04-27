extends Node

var room_tscn = preload ("res://Scenes/room.tscn")

@onready var user_name_label = $"控制页/外包/MarginContainer/中间堆叠/名字"

@onready var room_search_editor = $"控制页/外包/左侧堆叠/Margin列表房间面板/Panal列表房间面板/Margin内列表房间面板/VBox列表房间面板/房间号搜索面板/Editor房间号"

@onready var room_create_id_editor = $"控制页/外包/右侧堆叠/Margin创建房间面板/Panal创建房间面板/Margin内创建房间面板/VBox创建房间面板/创建房间表单/Editor房间号"
@onready var room_create_password_editor = $"控制页/外包/右侧堆叠/Margin创建房间面板/Panal创建房间面板/Margin内创建房间面板/VBox创建房间面板/创建房间表单/Editor密码"

@onready var room_join_id_editor = $"控制页/外包/右侧堆叠/Margin加入房间面板/Panel加入房间面板/Margin内加入房间面板/VBox加入房间面板/加入房间表单/Editor房间号"
@onready var room_join_password_editor = $"控制页/外包/右侧堆叠/Margin加入房间面板/Panel加入房间面板/Margin内加入房间面板/VBox加入房间面板/加入房间表单/Editor密码"

@onready var room_grid: GridContainer = $"控制页/外包/左侧堆叠/Margin列表房间面板/Panal列表房间面板/Margin内列表房间面板/VBox列表房间面板/Scroll房间列表/Grid房间列表"

@onready var roomPageHttpRequest: HTTPRequest = $RoomPageHTTPRequest

func check_id_and_pwd(_id: String, pwd: String) -> bool:
  if len(_id) < 4 or len(pwd) != 4:
    DialogTool.show_dialoig('请输入正确的房间号或密码', false)
    return false
  return true

func _on_ready() -> void:
  TcwbSocket.connect("you_create_room", Callable(self, "_on_you_create_room_finished"))
  TcwbSocket.connect("you_join_room", Callable(self, "_on_you_join_room_finished"))
  user_name_label.text = Global.user_info['username']
  _on_room_search_button_pressed()

func _on_room_search_button_pressed() -> void:
  var key = room_search_editor.text
  roomPageHttpRequest.request(
    Global.BACKEND_URL + '/room/page?key=' + key + '&status=0',
    [Global.HEADER_CONTENT_TYPE_JSON, Global.HEADER_TCWB_TOKEN],
    HTTPClient.METHOD_GET,
    JSON.stringify({
      'key': key,
      'page': 0,
      'size': 0,
    }))

func _on_room_create_button_pressed() -> void:
  if check_id_and_pwd(room_create_id_editor.text, room_create_password_editor.text):
    TcwbSocket.request_create_room(room_create_id_editor.text, room_create_password_editor.text)

func _on_you_create_room_finished(info):
  if 'msg' in info and info['msg'] != '':
    DialogTool.show_dialoig(info['msg'], false)
  else:
    var room = room_tscn.instantiate()
    room.room_id = room_create_id_editor.text
    SceneChanger.next_scene(room)

func _on_room_join_button_pressed() -> void:
  if check_id_and_pwd(room_join_id_editor.text, room_join_password_editor.text):
    TcwbSocket.request_join_room(room_join_id_editor.text, room_join_password_editor.text)

func _on_you_join_room_finished(info):
  if 'msg' in info and info['msg'] != '':
    DialogTool.show_dialoig(info['msg'], false)
  else:
    var room = room_tscn.instantiate()
    room.room_id = room_create_id_editor.text
    SceneChanger.next_scene(room)

func _on_logout_button_pressed() -> void:
  TcwbSocket.disconnect_from_backend()
  SceneChanger.back_scene()

func _on_room_page_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
  var json = Global.parse_response(body)
  if Global.check_response_code(response_code, json):
    for child in room_grid.get_children():
      room_grid.remove_child(child)
      child.queue_free()
    for room in json['data']:
      var room_id_label = Label.new()
      room_id_label.text = room['id']
      room_grid.add_child(room_id_label)
      var room_label = Label.new()
      room_label.text = room['name']
      room_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
      room_grid.add_child(room_label)
      var join_button = Button.new()
      join_button.text = '加入'
      join_button.connect("pressed", _on_join_button_pressed.bind(room))
      room_grid.add_child(join_button)

func _on_join_button_pressed(room):
  room_join_id_editor.text = room['id']
