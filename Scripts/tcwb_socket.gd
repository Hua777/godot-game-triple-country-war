extends Node

const uuid_util = preload ('res://Addons/uuid/uuid.gd')

var socket = WebSocketPeer.new()

var disconnected = true
var need_to_online = true

signal you_create_room(info)
signal you_join_room(info)
signal room_info(info)
signal you_leave_room(info)
signal you_kick_out_user_from_room(info)
signal someone_join_room(info)
signal someone_leave_room(info)
signal you_kicked_out(info)
signal you_change_room_property(info)
signal room_property_changed(info)
signal user_ready_changed(info)
signal game_started(info)

func connect_to_backend():
  socket.connect_to_url("127.0.0.1:8090")

func disconnect_from_backend():
  socket.close()

func request_create_room(room_id, room_password):
  send_command('create-room', {
    'room_id': room_id,
    'room_name': room_id,
    'room_password': room_password,
  })

func request_join_room(room_id, room_password):
  send_command('join-room', {
    'room_id': room_id,
    'input_room_password': room_password,
  })

func request_room_info():
  send_command('room-info', {})

func request_leave_room():
  send_command('leave-room', {})

func request_kick_out_room(account):
  send_command('kick-out-user-from-room', {
    'account': account,
  })

func request_change_room_property(loyal_count, traitor_count, rebel_count):
  send_command('change-room-property', {
    'loyal_count': loyal_count,
    'traitor_count': traitor_count,
    'rebel_count': rebel_count,
  })

func request_ready_or_not():
  send_command('ready-or-not', {})

func request_start_game():
  send_command('start-game', {})

func send_ack(command: String, msg_id: String, info):
  info["msg_id"] = msg_id
  info["mode"] = "response"
  info["command"] = command
  print('[websocket] ack message %s' % info)
  socket.send_text(JSON.stringify(info))

func send_command(command: String, info):
  info["msg_id"] = uuid_util.v4()
  info["mode"] = "request"
  info["command"] = command
  print('[websocket] send message %s' % info)
  socket.send_text(JSON.stringify(info))

func parse_message(data: PackedByteArray):
  var data_str = data.get_string_from_utf8()
  print('[websocket] received message %s' % data_str)
  var value = JSON.parse_string(data_str)
  return [value["msg_id"],value["mode"],value["command"],value]

func _process(delta):
  var state = socket.get_ready_state()
  if state == WebSocketPeer.STATE_CONNECTING:
    socket.poll()
  elif state == WebSocketPeer.STATE_OPEN:
    disconnected = false
    if need_to_online:
      send_command('online', {
        'account': Global.user_info['account'],
      })
      need_to_online = false
    socket.poll()
    while socket.get_available_packet_count():
      var p = parse_message(socket.get_packet())
      var msg_id = p[0]
      var mode = p[1]
      var command = p[2]
      var info = p[3]
      if mode == 'response':
        if command == 'create-room':
          emit_signal("you_create_room", info)
        elif command == 'join-room':
          emit_signal("you_join_room", info)
        elif command == 'room-info':
          emit_signal("room_info", info)
        elif command == 'leave-room':
          emit_signal("you_leave_room", info)
        elif command == 'kick-out-user-from-room':
          emit_signal("you_kick_out_user_from_room", info)
        elif command == 'change-room-property':
          emit_signal("you_change_room_property", info)
      elif mode == 'request':
        if command == 'user-join':
          emit_signal("someone_join_room", info)
        elif command == 'user-leave':
          emit_signal("someone_leave_room", info)
        elif command == 'kick-out':
          emit_signal("you_kicked_out", info)
        elif command == 'room-property-changed':
          emit_signal("room_property_changed", info)
        elif command == 'user-ready-changed':
          emit_signal("user_ready_changed", info)
        elif command == 'game-started':
          emit_signal("game_started", info)
  elif state == WebSocketPeer.STATE_CLOSING:
    socket.poll()
  elif state == WebSocketPeer.STATE_CLOSED:
    if not disconnected:
      SceneChanger.pop_to_root_scene()
      disconnected = true
    need_to_online = true
