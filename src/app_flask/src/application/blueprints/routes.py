from flask import Blueprint, request, abort
import os
from urllib.request import urlopen
from bs4 import BeautifulSoup
from application import token, dbMysql, dbMongo

api = Blueprint('api', __name__)

@api.route('/healthcheck')
def healthcheck():
    return 'I am ok'

@api.route('/admin', methods=['POST'])
def admin():
    try:
        cookie = request.cookies['user']
        verify = token.verify_cookide(cookie)
        if verify != None:      
            if verify['user'] == 'Adm1n':  
                try:
                    return {'data': os.popen(f'ping -c 4 {request.json["host"]}').read()}
                except Exception as e:
                    return {'data': str(e)}       
    except:
        pass
    return {'data': 'non'}


@api.route('/comment', methods=['POST'])
def comment():
    com = request.json['comment'] or None
    if com == "" or com == None:
        return {'isSuccess' : False}
    isSuccess = dbMysql.addComment(com)
    return {'isSuccess' : isSuccess}

@api.route('/comments')
def data_comments():
    data = dbMysql.getComments()
    return {'data': data}

@api.route('/ssrf', methods=['POST'])
def ssrf_():
    url = request.json['url'] or None
    if url == None:
        return {'data' : "please, give me a url"}
    soup =  BeautifulSoup(urlopen(url), "html.parser" )
    return {'data' : str(soup)}

@api.route('/isAdmin')
def isAdmin():
    try:
        cookie = request.cookies['user']
        verify = token.verify_cookide(cookie)
        if verify != None:      
            return {'data': True if verify['user'] == 'Adm1n' else False}      
    except:
        pass
    return {'data': False}
    
@api.route('/login', methods=['POST'])
def login():
    username, password = request.json['username'], request.json['password']
    userFound = dbMysql.login(username, password)
    if userFound != None:
        return {'data' : True, 'cookie' : token.create_cookie(userFound)}
    return {'data' : False}

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