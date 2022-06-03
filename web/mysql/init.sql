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


insert into users(1, 'user','us3rpasswd');
insert into users(2, 'user1','us3rpasswd1');
insert into users(3, 'user2','us3rpasswd2');
insert into users(4, 'admin','St0ngP4sswd@!');
insert into users(5, 'user5','us3rpasswd5');

