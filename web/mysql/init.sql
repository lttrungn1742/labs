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


INSERT INTO users VALUES
(1,'BasicUser','us3rpasswd'),
(2,'Anna','us3rpasswd1'),
(3,'batman','us3rpasswd2'),
(4,'Adm1n','St0ngP4sswd@!'),
(5,'superman','us3rpasswd5');

INSERT INTO employees VALUES 
(0,"Le Van Hanh","1000"),
(0,"Bich Nguyen","3050"),
(0,"Truong Ba Thai","4040"),
(0,"Dang Hoang Hiep","6005"),
(0,"Phan Thanh Hy","1040"),
(0,"Nguyen Thi Thuy An","1070");


CREATE TABLE `jobs` (
  `id` int NOT NULL,
  `title` varchar(256) NOT NULL,
  `salary` int NOT NULL,
  `location` varchar(256) NOT NULL,
  `type` varchar(256) NOT NULL,
  `date` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `jobs` (`id`, `title`, `salary`, `location`, `type`, `date`) VALUES
(1, 'Graphic Designer', 2000, 'Houston', 'Freelance', '2021-09-15'),
(2, 'Project Manager', 4000, 'Dallas', 'Contract', '2021-09-10'),
(3, 'Product Designer', 3000, 'Austin', 'Full Time', '2021-09-03'),
(4, 'Marketing Manager', 4500, 'Amarillo', 'Full Time', '2021-09-12'),
(5, 'Content Engineer', 3000, 'San Antonio', 'Remote', '2021-08-07'),
(6, 'People Operations Manager', 2900, 'El Paso', 'Full Time', '2021-09-08'),
(7, 'Sales Executive', 2000, 'Arlington', 'Full Time', '2021-08-13'),
(8, 'Community Manager', 2700, 'Texas City', 'Remote', '2021-08-27');

ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `jobs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;