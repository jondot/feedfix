request = require('request')
libxmljs = require('libxmljs')
_ = require 'underscore'
express = require 'express'
app = express.createServer()
moment = require 'moment'


#
# call with this for example (encode parameters as needed):
#     $ curl http://datefixer.example.com?url=http://idiots.rss.com/stupidRSS.xml&datefields=pubDate&datefmt=ddd+MMM+DD+HH:mm:ss+z+YYYY
#
#     $ curl http://datefixer.example.com?url=http://idiots.rss.com/stupidRSS.xml&cleanid=guid
#
app.get '/', (req, res)->
  url = req.param 'url'
  date_fields = req.param 'datefields'
  date_fmt = req.param 'datefmt'
  cleanid = req.param 'cleanid'

  unless url && (cleanid || date_fields && date_fmt)
    return res.send(406, "missing required parameters")

  if cleanid
    handler = (node) ->
      n = node.get(cleanid)
      if n && n.text() 
        n.text n.text().split('?')[0]
  else
    date_fields = _.map date_fields.split(','), (f)-> f.trim()
    handler = (node) ->
      _.each date_fields, (df)->
        n = node.get(df)
        if n && n.text() 
          fuckedup_date = n.text()
          proper_date = moment(fuckedup_date, date_fmt)
          if proper_date
            n.text proper_date.format()

  request url, (error, response, body)->
    if error
      return res.send(406, "bad response from target url: #{error}")

    if (!error && response.statusCode == 200)
      xmlDoc = libxmljs.parseXml(body)

      gchild = xmlDoc.find('//item')

      _.each gchild, handler

      res.end xmlDoc.toString()

port = process.env.PORT || 4000

console.log "feedfix up on #{port}"
app.listen port

