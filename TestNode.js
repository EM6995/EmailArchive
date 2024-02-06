// Built by LucyBot. www.lucybot.com
request.post({
  url: "https://api.smtp2go.com/v3/email/send",
  headers: {
    'Content-Type': "application/json"
  },
  body: JSON.stringify({
    'api_key': "api-7D3EF96493994248821658D944063C73",
    'sender': "ed@woowho.net",
    'to': [
      "ewmpe@proton.me"
    ],
    'subject': "TM-03",
    'text_body': "Tony, Bring the large grill.",
    'html_body': "<html><head><meta charset=\"utf-8\"><title>Markdown Cheat Sheet.md</title><style></style></head><body id=\"preview\"> <h4 class=\"code-line\" data-line-start=\"0\" data-line-end=\"1\"><a id=\"Thursday_pancake_breakfast_0\"></a>Thursday pancake breakfast</h4> <p class=\"has-line-data\" data-line-start=\"2\" data-line-end=\"4\">Tony,<br> Try to bring the large grill with you Thursday morning. Also extra pancake syrup if you can find it in the shed.</p> <p class=\"has-line-data\" data-line-start=\"5\" data-line-end=\"7\">Thanks,<br> Ed</p> </body></html>"
  }),
}, function(err, response, body) {
  console.log(body);
})
