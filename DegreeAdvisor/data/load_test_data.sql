-- TEST DATA
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Records;

CREATE TABLE Students(StudentId int);
INSERT INTO Students VALUES(1);
INSERT INTO Students VALUES(2);
INSERT INTO Students VALUES(3);
INSERT INTO Students VALUES(4);

CREATE TABLE Records(StudentId int, CourseId TEXT, Grade TEXT);

-- Record for Student ID 1
INSERT INTO Records VALUES(1, 'CSCI 160', 'B');
INSERT INTO Records VALUES(1, 'CSCI 161', 'A');
INSERT INTO Records VALUES(1, 'CSCI 473', 'NA');

-- Record for Student ID 2
INSERT INTO Records VALUES(2, 'CSCI 366', 'F');
INSERT INTO Records VALUES(2, 'CSCI 467', 'F');
INSERT INTO Records VALUES(2, 'CSCI 459', 'NA');

-- Record for Student ID 3
INSERT INTO Records VALUES(3, 'CSCI 222', 'A');
INSERT INTO Records VALUES(3, 'CSCI 313', 'B');
INSERT INTO Records VALUES(3, 'CSCI 445', 'A');

-- Record for Student Id 4
INSERT INTO Records VALUES(4, 'CSCI 222', 'A');
INSERT INTO Records VALUES(4, 'CSCI 313', 'A');
INSERT INTO Records VALUES(4, 'CSCI 445', 'A');
INSERT INTO Records VALUES(4, 'CSCI 366', 'A');
INSERT INTO Records VALUES(4, 'CSCI 467', 'A');
INSERT INTO Records VALUES(4, 'CSCI 459', 'A');