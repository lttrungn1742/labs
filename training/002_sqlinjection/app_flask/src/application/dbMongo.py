import pymongo, os

con = pymongo.MongoClient(os.getenv('MONGODB_CONNSTRING'))
db = con["data"]
user = db["users"]

def sqli(username, password):
  try:
    list = [element for element in user.find({ 'username': username, 'password': password} , {"_id": 0})]
    return True if list != [] else False
  except:
    return False


