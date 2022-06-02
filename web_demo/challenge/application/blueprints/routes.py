from flask import Blueprint, redirect, request, render_template, abort, make_response
from application.util import extract_from_archive
import sqlite3, os
from urllib.request import urlopen
from bs4 import BeautifulSoup

web = Blueprint('web', __name__)
api = Blueprint('api', __name__)

con = sqlite3.connect(f'{os.getcwd()}/data.db', check_same_thread=False)
cur = con.cursor()
secret_cookie = f"Cookie_{os.urandom(10).hex()}_right_cookie"

try:
    cur.execute('''CREATE TABLE users
                    (username text, password text)''')
    cur.execute('''CREATE TABLE comments
                    (comment text)''')
    cur.execute("INSERT INTO users VALUES ('admin','VietLink@1')")
    con.commit()
except sqlite3.OperationalError:
    pass

@web.route('/')
def index():
    return render_template('index.html')

@web.route('/upload')
def upload():
    return render_template('upload.html')

@web.route('/xss')
def xss():
    return render_template("xss.html")

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
    cur.execute("INSERT INTO comments VALUES ('{}')".format(com))
    con.commit()
    return {'isSuccess' : True}

@web.route('/comments')
def data_comments():
    data = [row[0] for row in cur.execute('SELECT comment FROM comments')]
    if len(data) > 10:
        cur.execute("Delete from comments")
        con.commit()
    return {'data': data}

@web.route('/ssrf')
def ssrf():
    return render_template('ssrf.html')

@api.route('/ssrf', methods=['POST'])
def ssrf_():
    url = request.json['url'] or None
    if url == None:
        return {'data' : "please, give me a url"}
    req = urlopen
    soup =  BeautifulSoup(req(url), "html.parser" )
    return {'data' : str(soup)}

@web.route('/admin')
def admin():
    try:
        if request.cookies['user'] == secret_cookie:
            return render_template('admin.html')
        else:
            return redirect('/login')
    except:
        return redirect('/login')
      
@api.route('/admin', methods=['POST'])
def admin_():
    try:
        if request.cookies['user'] != None:        
            try:
                return {'data': os.popen(f'ping -c 4 {request.json["host"]}').read()}
            except Exception as e:
                return {'data': str(e)}
    except:
        return redirect('/login')
    
@web.route('/login')
def login():
    return render_template('login.html')

@api.route('/login', methods=['POST'])
def login_():
    username, password = request.json['username'], request.json['password']
    sql = 'select username from users where username=? and password=?'
    val = (username, password)
    result = cur.execute(sql, val).fetchone()

    if result != None:
        return {'data' : True, 'cookie' : secret_cookie}
    return {'data' : False}