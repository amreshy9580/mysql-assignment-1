USE Assignment_1;

INSERT INTO departments VALUES
(1,'HR','New York'),
(2,'Finance','Chicago'),
(3,'IT','San Francisco'),
(4,'Sales','Dallas'),
(5,'Marketing','Boston'),
(6,'Operations','Seattle'),
(7,'Support','Miami'),
(8,'Legal','Atlanta'),
(9,'R&D','Austin'),
(10,'Admin','Denver');

INSERT INTO employees VALUES
(101,'John','Smith','john.smith@email.com','2020-01-15',75000.00,1,NULL),
(102,'Emma','Johnson','emma.j@email.com','2021-03-10',65000.00,2,101),
(103,'Liam','Brown','liam.b@email.com','2019-06-20',85000.00,3,101),
(104,'Olivia','Davis','olivia.d@email.com','2022-02-18',55000.00,4,103),
(105,'Noah','Wilson','noah.w@email.com','2021-08-25',60000.00,5,103),
(106,'Sophia','Taylor','sophia.t@email.com','2020-11-11',70000.00,6,101),
(107,'James','Anderson','james.a@email.com','2023-01-05',48000.00,7,106),
(108,'Ava','Thomas','ava.t@email.com','2022-07-15',62000.00,8,106),
(109,'William','Moore','william.m@email.com','2021-09-30',78000.00,9,103),
(110,'Mia','Martin','mia.m@email.com','2023-05-12',50000.00,10,101);

INSERT INTO categories VALUES
(1,'Electronics'),(2,'Clothing'),(3,'Books'),(4,'Furniture'),(5,'Toys'),
(6,'Sports'),(7,'Groceries'),(8,'Beauty'),(9,'Automotive'),(10,'Jewelry');

INSERT INTO products VALUES
(1,'Laptop',1,950.00,20),(2,'T-Shirt',2,25.50,150),(3,'Novel',3,15.00,100),
(4,'Office Chair',4,180.00,40),(5,'Football',6,30.00,60),(6,'Toy Car',5,18.00,80),
(7,'Rice Bag',7,40.00,120),(8,'Face Cream',8,22.50,75),(9,'Car Battery',9,150.00,25),
(10,'Gold Ring',10,500.00,10);

INSERT INTO customers VALUES
(1,'Alice','Brown','alice@email.com','New York','NY','2023-01-05'),
(2,'Bob','Smith','bob@email.com','Chicago','IL','2023-02-10'),
(3,'Charlie','Johnson','charlie@email.com','Dallas','TX','2023-03-15'),
(4,'David','Wilson','david@email.com','Miami','FL','2023-04-20'),
(5,'Eva','Thomas','eva@email.com','Boston','MA','2023-05-25'),
(6,'Frank','Martin','frank@email.com','Seattle','WA','2023-06-12'),
(7,'Grace','Lee','grace@email.com','Austin','TX','2023-07-08'),
(8,'Henry','Clark','henry@email.com','Denver','CO','2023-08-14'),
(9,'Isabella','Hall','isabella@email.com','Atlanta','GA','2023-09-01'),
(10,'Jack','Young','jack@email.com','Phoenix','AZ','2023-10-10');

INSERT INTO orders VALUES
(1001,1,'2024-01-05',950.00,'Shipped'),(1002,2,'2024-01-08',25.50,'Pending'),
(1003,3,'2024-01-10',195.00,'Delivered'),(1004,4,'2024-01-12',30.00,'Cancelled'),
(1005,5,'2024-01-15',40.00,'Shipped'),(1006,6,'2024-01-18',22.50,'Delivered'),
(1007,7,'2024-01-20',150.00,'Pending'),(1008,8,'2024-01-22',500.00,'Delivered'),
(1009,9,'2024-01-25',15.00,'Shipped'),(1010,10,'2024-01-28',180.00,'Pending');

INSERT INTO order_items VALUES
(1,1001,1,1,950.00),(2,1002,2,1,25.50),(3,1003,4,1,180.00),
(4,1003,3,1,15.00),(5,1004,5,1,30.00),(6,1005,7,1,40.00),
(7,1006,8,1,22.50),(8,1007,9,1,150.00),(9,1008,10,1,500.00),
(10,1010,4,1,180.00);

INSERT INTO students VALUES
(1,'Aarav','Sharma',18,'12th','2023-06-10'),(2,'Diya','Patel',17,'11th','2023-06-12'),
(3,'Rohan','Verma',16,'10th','2023-06-15'),(4,'Ananya','Singh',15,'9th','2023-06-18'),
(5,'Kabir','Mehta',18,'12th','2023-06-20'),(6,'Sneha','Joshi',17,'11th','2023-06-25'),
(7,'Arjun','Gupta',16,'10th','2023-07-01'),(8,'Meera','Kapoor',15,'9th','2023-07-05'),
(9,'Vivaan','Nair',18,'12th','2023-07-10'),(10,'Isha','Reddy',17,'11th','2023-07-15');

INSERT INTO courses VALUES
(1,'Mathematics',4.00),(2,'Physics',3.00),(3,'Chemistry',3.00),(4,'Biology',4.00),
(5,'English',2.00),(6,'History',2.00),(7,'Computer Sci',4.00),(8,'Economics',3.00),
(9,'Statistics',3.00),(10,'Psychology',2.00);

INSERT INTO enrollments VALUES
(1,1,1,88,'2023-08-01'),(2,2,2,91,'2023-08-01'),(3,3,3,76,'2023-08-02'),
(4,4,4,84,'2023-08-02'),(5,5,5,95,'2023-08-03'),(6,6,6,80,'2023-08-03'),
(7,7,7,89,'2023-08-04'),(8,8,8,92,'2023-08-04'),(9,9,9,85,'2023-08-05'),
(10,10,10,90,'2023-08-05');
