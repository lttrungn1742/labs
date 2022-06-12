#!/bin/ash
mongod --noauth --dbpath /tmp/mongodb/ &
sleep 2
mongo data --eval "db.dropDatabase()"
mongo data --eval "db.createCollection('users')"
mongo data --eval 'db.users.insert( { username: "admin", password: "VietlinkSqliNosqlExplotSuccess"} )'
mongo data --eval 'db.users.insert( { username: "trung", password: "Str0ngP4ssw0rd"} )'
mongo data --eval 'db.users.insert( { username: "BanDa", password: "P4ssW0rd7942323"} )'
