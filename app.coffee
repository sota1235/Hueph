path      = require 'path'
express   = require 'express'

app = express()

app.set 'port', process.env.PORT || 3000
app.set 'view engine', 'jade'
app.set 'views', path.resolve 'views/'

app.use express.static path.resolve 'public/'

app.get '/', (req, res) ->
  res.render 'index'

app.get '/hueph_volume', (req, res) ->
  res.render 'hueph_volume'

app.get '/hueph_kick', (req, res) ->
  res.render 'hueph_kick'

# for debug the client js
app.get '/test', (req, res) ->
  res.render 'test'

app.listen app.get 'port'
