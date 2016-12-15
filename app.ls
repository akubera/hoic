

require! {
    \express
    \path
    \morgan : logger
    \cookie-parser
    \body-parser

}

as-local-dir = (...args) -> path.join __dirname, ...args


module.exports = app = express()

app.set('views', as-local-dir('views'));
app.set('view engine', 'pug');

app
  ..use logger('dev')
  ..use body-parser.json()
  ..use body-parser.urlencoded({ extended: false })
  ..use cookie-parser()

  ..use require('livescript-middleware') do
    src: as-local-dir('client')
    dest: as-local-dir('cache', 'public')
    bare: true

  ..use(express.static(as-local-dir(\public)))
  ..use(express.static(as-local-dir(\node_modules/intercooler/www/release)))
  ..use(express.static(as-local-dir(\node_modules/jquery/dist)))

app.use (req, res, next) ->

  next()


app.get \/ (req, res, next) ->
  res.render('index', { title: 'Express' })

app.post \/click (req, res) ->
  console.log req.body
  res.json do
    foo: \bar
    res: req.body.a

app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next(err)

app.use (err, req, res, next) ->
  res.status(err.status || 500)
  res.render('error', {
        message: err.message,
        error: err })
