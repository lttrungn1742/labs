docker run -v /tmp:/zap/wrk/:rw -t owasp/zap2docker-stable zap-full-scan.py -t http://127.0.0.1 -r report_zap.html
