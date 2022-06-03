create database data;

use data;

create table users(
    id INT AUTO_INCREMENT, 
    username TEXT, 
    passwd TEXT,
    PRIMARY KEY(id)
);


create table comments(
    comments TEXT
);

create table employees(
    id int PRIMARY KEY AUTO_INCREMENT,
    name INT,
    salary INT
);


insert into users values (1,'user','us3rpasswd');
insert into users values (2,'user1','us3rpasswd1');
insert into users values (3,'user2','us3rpasswd2');
insert into users values (4,'admin','St0ngP4sswd@!');
insert into users values (5,'user5','us3rpasswd5');

