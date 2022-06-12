import pymongo, os

con = pymongo.MongoClient(os.getenv('MONGODB_CONNSTRING'))
user = con["data"]["users"]

result = user.find({  'username' : {'$ne' :'a'}  , 'password':{'$regex' :'^P'}      },{'_id':0})

for row in result:
    print(row)