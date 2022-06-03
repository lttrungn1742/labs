from flask import Blueprint, redirect, request, abort
from application.util import extract_from_archive
import os
from urllib.request import urlopen
from bs4 import BeautifulSoup
from application import db, token

api = Blueprint('api', __name__)

@api.route('/healthcheck')
def healthcheck():
    return 'I am ok'

@api.route('/unslippy', methods=['POST'])
def cache():
    if 'file' not in request.files:
        return abort(400)
    
    extraction = extract_from_archive(request.files['file'])
    if extraction:
        return {"list": extraction}, 200

    return '', 204

@api.route('/comment', methods=['POST'])
def comment():
    com = request.json['comment'] or None
    if com == "" or com == None:
        return {'isSuccess' : False}
    # com = com.replace('>','&#62;').replace('<','&lt;').replace('󠀼󠀼󠀼<','&#917564;').replace('>','&#917566;').replace('"','&quot;').replace("'",'&apos;')
    isSuccess = db.addComment(com)
    return {'isSuccess' : isSuccess}

@api.route('/comments')
def data_comments():
    data = db.getComments()
    return {'data': data}

@api.route('/ssrf', methods=['POST'])
def ssrf_():
    url = request.json['url'] or None
    if url == None:
        return {'data' : "please, give me a url"}
    soup =  BeautifulSoup(urlopen(url), "html.parser" )
    return {'data' : str(soup)}

@api.route('/admin', methods=['POST'])
def admin_():
    try:
        cookie = request.cookies['user']
        verify = token.verify_cookide(cookie)
        if verify != None:      
            if verify['user'] == 'admin':  
                try:
                    return {'data': os.popen(f'ping -c 4 {request.json["host"]}').read()}
                except Exception as e:
                    return {'data': str(e)}
            else:
                return {'data': 'non admin'}
        else:
            return {'data': 'unvalidated cookie'}        
    except:
        return redirect('/login')
    
@api.route('/login', methods=['POST'])
def login_():
    username, password = request.json['username'], request.json['password']
    userFound = db.login(username, password)
    if userFound != None:
        return {'data' : True, 'cookie' : token.create_cookie(userFound)}
    return {'data' : False}