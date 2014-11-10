# Hue controller
#
# Author:
#   sota1235

class HueController

  constructor: (ip, user) ->
    @ip   = ip
    @user = user
    @url  = "http://" + ip + "/api"

  request = (uri, method, data, callback = () ->) ->
    param =
      url    : @url + uri
      type   : method
      success: (msg) ->
        callback null, msg
      error  : (err) ->
        callback err, null
    # add data to param if 'POST' or 'PUT'
    if method != 'GET'
      param['data'] = data
    $.ajax param

  lightTrriger: (light, trigger, callback = ->) ->
    uri = '/' + @user + '/lights/' + light.toString() + '/state'
    method = 'PUT'
    data =
      'on': if trigger then true else false
    request.call this, uri, method, data, (err, json) ->
      if err
        callback err, null
      else
        callback null, json

  changeBri: (light, bri, callback = ->) ->
    uri = '/' + @user + '/lights/' + light.toString() + '/state'
    method = 'PUT'
    data =
      'bri': bri
    request.call this, uri, method, data, (err, json) ->
      if err
        callback err, null
      else
        callback null, json

  effectTrriget: (light, trigger, callback = ->) ->
    uri = '/' + @user + '/lights/' + light.toString() + '/state'
    method = 'PUT'
    data =
      'effect': if trigger then 'colorloop' else 'none'
    request.call this, uri, method, data, (err, json) ->
      if err
        callback err, null
      else
        callback null, json
