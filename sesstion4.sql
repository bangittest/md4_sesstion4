create database qlsv;
use qlsv;


create table class(
	classID int not null primary key auto_increment,
    className varchar(60),
    startDate datetime default(current_date()) default(current_time()) not null,
    status bit
);

insert into class(className,startDate,status)values('A','2023-09-12 00:38:23',1);
insert into class(className,startDate,status)values('B','2023-10-17 00:38:31',1);
insert into class(className,startDate,status)values('B','2023-12-15 00:38:21',1);
insert into class(className,startDate,status)values('E','2023-12-22 00:38:10',1);

create table student(
	studentID int not null primary key auto_increment,
    studentName varchar(30) not null,
    address varchar(50),
    phone varchar(20),
    status bit,
    classID int not null,
    foreign key(classID)references class(classID)
);

insert into student(studentName,address,phone,status,classID)values('nguyen van A','Ha noi','0968783032',1,1);
insert into student(studentName,address,phone,status,classID)values('nguyen van B','Ha noi','0968783032',1,2);
insert into student(studentName,address,phone,status,classID)values('nguyen van C','Ha noi','0968783032',1,3);
insert into student(studentName,address,phone,status,classID)values('nguyen van D','Ha noi','0968783032',1,4);
insert into student(studentName,address,phone,status,classID)values('nguyen van E','Ha nam','0968783032',1,3);
insert into student(studentName,address,phone,status,classID)values('nguyen van F','Ha long','0968783032',1,4);

create table subject(
subID int not null primary key auto_increment,
subName varchar(30) not null,
creadit tinyint not null default(1) check(creadit>=1),
status bit default(1)
);

insert into subject(subName,creadit)values('jack','9');
insert into subject(subName,creadit)values('hong hanh','4');
insert into subject(subName,creadit)values('jack ma','3');
insert into subject(subName,creadit)values('jack 2','8');

select * from subject;



create table mark(
	markID int not null primary key auto_increment,
    subID int not null unique key,
    foreign key(subID)references subject(subID),
    studentID int not null unique key,
    foreign key(studentID)references student(studentID),
    mark float default(0) check(mark between 0 and 100) not null,
    examTimes tinyint default(1)
);

insert into mark(subID,studentID)values(1,1);
insert into mark(subID,studentID,mark)values(2,2,60);
insert into mark(subID,studentID,mark)values(3,3,80);
insert into mark(subID,studentID,mark)values(4,4,20);

--  Sử dụng hàm count để hiển thị số lượng sinh viên ở từng nơi
select address,count(studentId) as 'so luong hoc vien'
from student
group by address;

-- Tính điểm trung bình các môn học của mỗi học viên bằng cách sử dụng hàm AVG
select s.studentId,s.studentName,avg(mark)
from student s
join mark m
on s.studentId=m.studentId
group by s.studentId,s.studentName;

-- Hiển thị những bạn học viên co điểm trung bình các môn học lớn hơn 15
-- Sử dụng having để xét điều kiện điểm trung bình các môn học phải lớn hơn 15
select s.studentId,s.studentName,avg(mark)
from student s
join mark m
on s.studentId=m.studentId
group by s.studentId,s.studentName
having avg(mark)>15;

-- Hiển thị danh sách điểm trung bình của các học viên
-- Sử dụng Having và All để tìm học viên có điểm trung bình lớn nhất

select s.studentId, s.studentName,avg(mark)
from student s
join mark m
on s.studentId=m.studentId
group by s.studentId,s.studentName
having avg(mark)>=all(select avg(mark) from mark group by mark.studentId);

-- baitap
-- • Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
SELECT *
FROM subject
WHERE creadit = (SELECT MAX(creadit) FROM subject);

select *
from subject
group by subId,subName
having creadit>=all(select creadit from subject group by subID);


-- • Hiển thị các thông tin môn học có điểm thi lớn nhất.
select s.studentId,s.studentName,s.address,m.mark
from student s
join mark m
on m.studentId=s.studentId
group by s.studentId,s.studentName,s.address
having m.mark>=all(select mark from mark group by studentID);

-- • Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần
select s.*,m.mark
from student s
join mark m
on m.studentId=s.studentId
group by s.studentID,s.studentName
order by m.mark desc
