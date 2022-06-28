from flask import Flask, jsonify, redirect, render_template, send_from_directory, request, session
import os, logging
from application import db

app = Flask(__name__)
app.secret_key = os.urandom(50).hex()

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not Found'}), 404

@app.errorhandler(403)
def forbidden(error):
    return jsonify({'error': 'Not Allowed'}), 403

@app.errorhandler(400)
def bad_request(error):
    return jsonify({'error': 'Bad Request'}), 400

@app.route('/static/<path:path>')
def send_report(path):
    return send_from_directory('static', path)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['POST'])
def login():    
    id = db.login(request.form['username'], request.form['password'])
    if id != None:
        session['id_user'] = id
        return redirect('/profile')
    return render_template('index.html')

@app.route('/profile')
def profile():
    tmp = db.getBanking(session['id_user'])
    return render_template('profile.html', data={'username': tmp[0], 'money': tmp[1], 'id_bank': tmp[2] })

@app.route('/banking', methods=['POST', 'GET'])
def banking():
    if request.method == 'GET':
        return redirect('/profile')
    id_banking = request.form['id_bank']
    money = request.form['money']
    result = db.banking(id_banking, session['id_user'], money)
    tmp = db.getBanking(session['id_user'])
    return render_template('profile.html', data={'username': tmp[0], 'money': tmp[1], 'id_bank': tmp[2], 'message': result })

@app.before_request
def intercept():
    if request.path in ['/profile', '/banking']:
        try:
            logging.debug(session['id_user'])
        except:
            return redirect('/')    
        