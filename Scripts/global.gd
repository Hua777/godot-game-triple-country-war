extends Node

var user_info: Dictionary = {}
var tcwb_token: String = ''

const BACKEND_URL = "http://127.0.0.1:8080"
const HEADER_CONTENT_TYPE_JSON = "Content-Type: application/json"

var HEADER_TCWB_TOKEN: String:
  get:
    return "tcwb-token: " + tcwb_token


func parse_response(body: PackedByteArray):
  var json = JSON.parse_string(body.get_string_from_utf8())
  print("[http] got response %s" % json)
  return json

func check_response_code(response_code: int, json) -> bool:
  if response_code == 200:
    return true
  else:
    DialogTool.show_dialoig(json['msg'], false)
    return false
