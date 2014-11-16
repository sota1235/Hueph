# Hue controller
#
# Author:
#   sota1235

class HueController

  constructor: (ip, user) ->
    @ip   = ip
    @user = user
    @url  = "http://" + ip + "/api/"

  request = (uri, method, data) ->
    dfd = $.Deferred()
    param =
      url    : @url + uri
      type   : method
      success: (msg) ->
        dfd.resolve $.parseJSON msg
        return dfd.promise()
      error  : (err) ->
        dfd.reject error
        return dfd.promise()
    # add data to param if 'POST' or 'PUT'
    if method != 'GET'
      param['data'] = data
    $.ajax param

  # 成功したらライトの数をreturn, ダメだったらfalse
  getLights: () ->
    dfd = $.Deferred()
    uri = @user + '/lights'
    method = 'GET'
    request.call this, uri, method, null
      .then (result) ->
        if result.length == 1
          dfd.resolve false
        else
          dfd.resolve result.length
        return dfd.promise()
      .fail (err) ->
        dfd.reject err
        return dfd.reject()

  # リクエストのtrue or falseをreturn
  lightTrriger: (light, trigger) ->
    uri = '/' + @user + '/lights/' + light.toString() + '/state'
    method = 'PUT'
    data =
      'on': trigger
    request.call this, uri, method, data
      .then (result) ->
        res = result[0]["error"] == undefined
        dfd.resolve res
        return dfd.promise()
      .fail (err) ->
        dfd.reject err
        return dfd.promise()

  # リクエストのtrue or falseをreturn
  changeBri: (light, bri) ->
    uri = '/' + @user + '/lights/' + light.toString() + '/state'
    method = 'PUT'
    data =
      'bri': bri
    request.call this, uri, method, data
      .then (result) ->
        res = result[0]["error"] == undefined
        dfd.resolve res
        return dfd.promise()
      .fail (err) ->
        dfd.reject err
        return dfd.promise()

  # リクエストのtrue or falseをreturn
  effectTrriget: (light, trigger) ->
    uri = '/' + @user + '/lights/' + light.toString() + '/state'
    method = 'PUT'
    data =
      'effect': if trigger then 'colorloop' else 'none'
    request.call this, uri, method, data
      .then (result) ->
        res = result[0]["error"] == undefined
        dfd.resolve res
        return dfd.promise()
      .fail (err) ->
        dfd.reject err
        return dfd.promise()
