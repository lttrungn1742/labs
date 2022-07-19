code = ''.__class__.__mro__[2].__class__

print(code)


# code = """ __import__('os').__dict__['system']('ls') """

# print(eval(code))