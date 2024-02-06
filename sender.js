//const request = require('request')

var smtpurl = 'https://api.smtp2go.com/v3/email/send'

var smtpob = (name, email) => {
  return {
    'api_key': 'api-7D3EF96493994248821658D944063C73',
    'to': [`${name} <${email}>`],
    'sender': 'E.Marshall <ed@woowho.net>',
    'subject': 'A Subject',
    'text_body': 'Tony, this is pretty important. regards, Ed'
  }
}

module.exports = function () {
  function send (name, email) {
    var src = smtpob(name, email)

    request
          .post({
            headers: {'content-type': 'application/json'},
            url: smtpurl,
            body: JSON.stringify(src)
          })
          .on('response', function (response) {
            if (response.statusCode !== 200) {
              console.log(response.statusCode)
              console.log(response.statusMessage)
            }
          })
          .on('data', function (data) {
            console.log('decoded chunk: ' + data)
          })
          .on('error', function (err) {
            console.log('Email sender', err)
          })
  }

  return {send: send}
}

