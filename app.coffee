express = require 'express'
qs = require 'querystring'
app = express.createServer()

app.configure ->
	app.use express.logger('tiny')
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use app.router
	app.use express.static(__dirname + '/')
	app.use express.errorHandler({ dumpExceptions: true, showStack: true })

retrieveName = (req, callback) ->
    name = req.body.name
    if name?
        callback name
    else
        data = ""
        req.on "data", (chunk)-> data += chunk
        req.on "end", ->
            parsedData = qs.parse data
            name = parsedData.name
            callback name

app.post '/mrnobody', (req, res) ->
 	retrieveName req, (name) ->
	    res.header "Access-Control-Allow-Origin", '*'
	    res.header "Access-Control-Max-Age", '86400'	# 1 day
	    res.header 'Access-Control-Allow-Methods', 'POST,OPTIONS'
	    res.header "Access-Control-Allow-Headers", "X-Requested-With"
	    res.send "Hi Mr. #{name}!"

app.listen 3000
console.log "Express server listening on port #{app.address().port} in #{app.settings.env} mode"
