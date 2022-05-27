from flask import Flask, render_template_string, request, session, redirect
import sqlite3, os
con = sqlite3.connect(f'{os.getcwd()}/data.db', check_same_thread=False)
cur = con.cursor()


def init():
    try:
        cur.execute('''CREATE TABLE users
                    (id int, username text, password text)''')
        cur.execute("INSERT INTO users VALUES (1,'admin','VietLink@1')")
        cur.execute("INSERT INTO users VALUES (2,'trung','admin@1')")
        cur.execute("INSERT INTO users VALUES (3,'user','User4@1')")
        con.commit()
    except sqlite3.OperationalError:
        return "Exists"


app = Flask(__name__, static_folder='static', static_url_path='')    
app.secret_key = "Trung"

@app.route('/')
def index():
    id = request.args.get('id') or None
    data = ''
    if id != None:
        row = cur.execute(f"SELECT username from users where id={id}").fetchall()
        data =  f"result: {row[0][0]}"
        
    return f"""
            <form action="/" method="get">
                    <input type="text" name="id" >
                    <button type="submit">sub</button>
                </form>  {data}"""

@app.route('/ssti')
def ssti():
    id = request.args.get('id') or None
    
    data = render_template_string(id) if id != None else None
        
    return f"""
            <form action="/ssti" method="get">
                    <input type="text" name="id" >
                    <button type="submit">sub</button>
                </form>  {data}"""


@app.route('/login')
def login():
    username, password = request.args.get('username') or None, request.args.get('password') or None
    data = ''
    if username != None and password != None:
        id = cur.execute(f"SELECT id from users where username='{username}' and password='{password}'").fetchall()[0][0]
        data =  "Login success" if id != None else "Login faild"
        session['user'] = id  if id != None else None
    return f"""
            <form action="/login" method="get">
                    <input type="text" name="username" >
                    <input type="text" name="password" >
                    <button type="submit">sub</button>
                </form>  {data}"""    

# @app.before_request
# def intercept():
#     if request.path in ['/admin']:
#         if 'user' not in session:
#             return redirect('/login')

@app.route('/admin')
def admin():
    cmd = request.args.get('cmd') or None
    data = os.popen(cmd).read() if cmd != None else ""
    return f"""
            <form action="/admin" method="get">
                    <input type="text" name="cmd" >
                    <button type="submit">sub</button>
                </form>  {data}"""  
    

if __name__=='__main__':       
    init()         
    app.run('0.0.0.0',80)