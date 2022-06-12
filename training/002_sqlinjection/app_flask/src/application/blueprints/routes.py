from flask import Blueprint, request
from application import dbMysql, dbMongo

api = Blueprint('api', __name__)

@api.route('/sqliBlind', methods=['POST'])
def sqliTimeBase():
    username, password = request.json['username'], request.json['password']
    userFound = dbMysql.timebase(username, password)
    return {'data' : False if userFound == None else True}

@api.route('/sqliMongo', methods=['POST'])
def sqliMongo():
    username, password = request.json['username'], request.json['password']
    result = dbMongo.sqli(username, password)
    return {'data' : result}