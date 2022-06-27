import mysql.connector, os, logging

logging.basicConfig(level=logging.DEBUG, format=f'%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')

con = mysql.connector.connect(
  host="database",
  user="root",
  password=os.getenv('passwdMysql'),
  database='data'
)

cursor = con.cursor()

def login(username, password):
  cursor.execute( "select id from users where username=%s and passwd=%s", (username, password,))
  result = cursor.fetchall()

  for row in result:
    return row[0]
  return None

def getBanking(id_user):
  cursor.execute( "select username, money, banking.id from banking, users where idUser=%s and idUser=users.id", (id_user, ))
  result = cursor.fetchone()
  logging.debug(result)
  return result[0], "{:,.2f}".format(result[1]), result[2] if result != None else None


def banking(id_banking, id_user, money):
  try:
    money = int(money)
  except:
    return "Vui lòng không nhập chữ cái"
  cursor.execute("select money, id from banking where idUser=%s LIMIT 1", (id_user,))
  money_own, id_own = cursor.fetchone()

  logging.debug("money of own: '{own_money}', money send: '{send_money}', is greater than: '{is_greater}'".format(own_money="{:,.2f}".format(money_own), send_money="{:,.2f}".format(money), is_greater=money_own>money))
  if money_own > money:
    cursor.execute( "select  money from banking where id=%s LIMIT 1", (id_banking, ))    
    try:
      money_recive = cursor.fetchone()[0] + money 
    except Exception as e:
      logging.debug(e)
      return "Không tìm thấy tài khoản nhận tiền"

    cursor.execute("UPDATE banking set money=%s where id=%s", (money_recive,id_banking,))   
    con.commit()
    logging.debug(f"update bank of reciver affected {cursor.rowcount}")

    cursor.execute("UPDATE banking SET money=%s where id=%s", (money_own-money, id_own,))
    con.commit()
    logging.debug(f"update bank of sender affected {cursor.rowcount}")
    return  "Chuyển tiền thành công"
  return "Số dư không đủ"