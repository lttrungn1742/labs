create database data;

use data;

create table users(
    int id AUTO_INCREMENT, 
    username text, 
    passwd char(128),
    primary key(id)
);


create comments(
    comments text
);


insert into users()