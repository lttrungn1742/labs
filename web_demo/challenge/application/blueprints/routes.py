from crypt import methods
from flask import Blueprint, request, render_template, abort
from application.util import extract_from_archive
import sqlite3, os
from urllib.request import urlopen
from bs4 import BeautifulSoup

web = Blueprint('web', __name__)
api = Blueprint('api', __name__)

con = sqlite3.connect(f'{os.getcwd()}/data.db', check_same_thread=False)
cur = con.cursor()

try:
    cur.execute('''CREATE TABLE users
                    (username text, password text)''')
    cur.execute('''CREATE TABLE comments
                    (comment text)''')
    cur.execute("INSERT INTO users VALUES (1,'admin','VietLink@1')")
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
    if request.form['comment'] == "":
        return {'isSuccess' : False}
    cur.execute("INSERT INTO comments VALUES ('{}')".format(request.form['comment']))
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
    url = request.form['url'] or None
    if url == None:
        return {'data' : "please, give me a url"}
    soup =  BeautifulSoup(urlopen(url), "html.parser" ) # .encode('UTF-8')
    return {'data' : str(soup)}