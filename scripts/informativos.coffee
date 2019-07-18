axios = require('axios')
config = require('../config')

module.exports = (robot) ->

  robot.hear /^bitcoin$/i, (res) ->
    res.send "Its better than state toilet paper!"

  robot.respond /get (.*) price/i, (res) ->
    params = 
      method: 'GET'
      url: 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
      qs:
        'start': '1'
        'limit': '5000'
        'convert': 'USD'
      headers: 
        'X-CMC_PRO_API_KEY': config['coinmarket_api_key']

    axios(params).then((resAxios) -> 
      content = resAxios.data

      quote = []
      for currency in content.data
        if currency.symbol is res.match[1]
          quote.push currency
          break
      
      res.send "#{res.match[1]} price is #{quote[0].quote["USD"].price.toFixed 2}\n"
      
    ).catch( (error) =>
      res.send(error)
    )
      
    