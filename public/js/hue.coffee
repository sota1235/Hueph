# Hue controller
#
# Author:
#   sota1235

class HueController

  constructor: (ip, user) ->
    @ip   = ip
    @user = user
    @url  = "http://" + ip + "/api"

  request = (uri, method, data) ->
    dfd = $.Deferred()
    param =
      url    : @url + uri
      type   : method
      success: (msg) ->
        dfd.resolve msg
        return dfd.promise()
      error  : (err) ->
        dfd.reject err
        return dfd.promise()
    # add data to param if 'POST' or 'PUT'
    if method != 'GET'
      param['data'] = data
    $.ajax param

  getLights: () ->
    dfd = $.Deferred()
    uri = '/' + @user + 'lights'
    method = 'GET'
    request.call this, uri, method, null
      .then (result) ->
        dfd.resolve result
        return dfd.promise()
      .fail (err) ->
        dfd.reject err
        return dfd.reject()

  lightTrriger: (light, trigger) ->
    uri = '/' + @user + '/lights/' + light.toString() + '/state'
    method = 'PUT'
    data =
      'on': if trigger then true else false
    request.call this, uri, method, data
      .then (result) ->
        dfd.resolve result
        return dfd.promise()
      .fail (err) ->
        dfd.reject err
        return dfd.promise()

  changeBri: (light, bri) ->
    uri = '/' + @user + '/lights/' + light.toString() + '/state'
    method = 'PUT'
    data =
      'bri': bri
    request.call this, uri, method, data
      .then (result) ->
        dfd.resolve result
        return dfd.promise()
      .fail (err) ->
        dfd.reject err
        return dfd.promise()

  effectTrriget: (light, trigger) ->
    uri = '/' + @user + '/lights/' + light.toString() + '/state'
    method = 'PUT'
    data =
      'effect': if trigger then 'colorloop' else 'none'
    request.call this, uri, method, data
      .then (result) ->
        dfd.resolve result
        return dfd.promise()
      .fail (err) ->
        dfd.reject err
        return dfd.promise()
