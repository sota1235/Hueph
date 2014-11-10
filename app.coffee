path      = require 'path'
express   = require 'express'
coffeeMid = require 'coffee-middleware'

app = express()

app.set 'port', process.env.PORT || 3000
app.set 'view engine', 'jade'
app.set 'views', path.resolve 'views/'

app.use express.static path.resolve 'public/'
app.use coffeeMid
  src: path.resolve 'public/'
  compress: true

app.get '/', (req, res) ->
  res.render 'index'

app.listen app.get 'port'
