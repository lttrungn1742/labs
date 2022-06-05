import jwt

secretKey = "SECRET_KEY"

def create_cookie(user):
    return  jwt.encode({"user": user}, secretKey, algorithm="HS256")

def verify_cookide(token):
    try:
        return jwt.decode(token, secretKey, algorithms="HS256")
    except jwt.exceptions.InvalidSignatureError:
        return None
