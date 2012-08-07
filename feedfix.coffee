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
app.get '/', (req, res)->
  url = req.param 'url'
  date_fields = req.param 'datefields'
  date_fmt = req.param 'datefmt'

  unless url && date_fields && date_fmt
    return res.send(406, "missing required parameters")

  date_fields = _.map date_fields.split(','), (f)-> f.trim()

  request url, (error, response, body)->
    if error
      return res.send(406, "bad response from target url: #{error}")

    if (!error && response.statusCode == 200)
      xmlDoc = libxmljs.parseXml(body)

      gchild = xmlDoc.find('//item')

      _.each gchild, (node)->
        _.each date_fields, (df)->
          n = node.get(df)
          if n && n.text() 
            fuckedup_date = n.text()
            proper_date = moment(fuckedup_date, date_fmt)
            if proper_date
              n.text proper_date.format()


      res.end xmlDoc.toString()

port = process.env.PORT || 4000

console.log "feedfix up on #{port}"
app.listen port

