import mysql.connector, os

mydb = mysql.connector.connect(
  host="database",
  user="root",
  password=os.getenv('passwdMysql'),
  database='data'
)

