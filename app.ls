

require! {
    \express
    \path
    \morgan : logger
    \cookie-parser
    \body-parser

}

module.exports = app = express()

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app
  ..use logger('dev')
  ..use body-parser.json()
  ..use body-parser.urlencoded({ extended: false })
  ..use cookie-parser()
  ..use(express.static(path.join(__dirname, 'public')));
  ..use(express.static(path.join(__dirname, 'node_modules/intercooler/www/release')));

app.get \/ (req, res, next) ->
  res.render('index', { title: 'Express' })

app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next(err)

app.use (err, req, res, next) ->
  res.status(err.status || 500)
  res.render('error', {
        message: err.message,
        error: err })
