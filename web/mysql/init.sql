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
    id int AUTO_INCREMENT,
    name TEXT,
    salary INT, PRIMARY KEY(id)
);


insert into users values (1,'user','us3rpasswd');
insert into users values (2,'user1','us3rpasswd1');
insert into users values (3,'user2','us3rpasswd2');
insert into users values (4,'admin','St0ngP4sswd@!');
insert into users values (5,'user5','us3rpasswd5');

insert into employees values (0,"Le Van Hanh","1000");
insert into employees values (0,"Bich Nguyen","3050");
insert into employees values (0,"Truong Ba Thai","4040");
insert into employees values (0,"Dang Hoang Hiep","6005");
insert into employees values (0,"Phan Thanh Hy","1040");
insert into employees values (0,"Nguyen Thi Thuy An","1070");