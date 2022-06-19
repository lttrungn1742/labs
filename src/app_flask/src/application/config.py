

class Config(object):
    SECRET_KEY = "asasasasa"
    UPLOAD_FOLDER = '/app/application/static/archives'

class ProductionConfig(Config):
    pass

class DevelopmentConfig(Config):
    DEBUG = True

class TestingConfig(Config):
    TESTING = True