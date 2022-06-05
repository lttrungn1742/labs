import mysql.connector, os, token

con = mysql.connector.connect(
  host="database",
  user="root",
  password=os.getenv('passwdMysql'),
  database='data'
)
cursor = con.cursor()

def addComment(com):
  try:
    cursor.execute("INSERT INTO comments VALUES ('{}')".format(com))
    con.commit()
    return True
  except:
    return False
  
def getComments():
  cursor.execute("SELECT * FROM comments")

  data = [row[0] for row in cursor.fetchall()]
  if len(data) > 5:
    cursor.execute("Delete from comments")
    con.commit()
  return data


def login(username, password):
  sql = "select username from users where username='" + username + "' and passwd='" + password + "'"
  try:
    cursor.execute(sql)
    result = cursor.fetchone()
    return result[0]
  except Exception as e:
    return None
  
  
  
  
  
