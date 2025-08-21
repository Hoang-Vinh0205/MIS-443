-- Final Exam MIS 443 Q4 - 2024-2025 - Skeleton
-- Your ID:
-- Your Name:
/*
Question 1 (10 marks): Create a database named “yourfullname” (e.g: dangthaidoan”) use PGAdmin, then create a schema name “cd” that has three tables: members, bookings and facilities 
using SQL statements. Ensure each table includes appropriate primary and foreign keys, and data types. 
Submit the SQL script as part of your answer.
*/

-- Q1.A Check tables
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'ba' 
ORDER BY table_name, ordinal_position;

-- Q1. B. check table student
-- Your answer here
SELECT * FROM students;
-- End your answer

/*
Question 2 (10 marks): Write an SQL query to find the top 3 facilities that have been booked the most number of total slots (not just number of bookings).
Display their facility ID and the total number of slots booked, sorted from highest to lowest.
*/
-- Your answer here
SELECT facid, SUM(slots) FROM ba.bookings
GROUP BY facid
ORDER BY SUM(slots) DESC
LIMIT 3;

-- End your answer
/*
Question 3 (20 marks): Write an SQL query to display all bookings that lasted more than 2 slots, along with the member ID, facility ID, and facility name, 
sorted by member ID and then by start time (ascending).
*/
-- Your answer here
SELECT b.bookid, b.memid, b.facid, f.name AS facility_name, b.starttime, b.slots
FROM ba.bookings AS b
JOIN ba.facilities AS f ON f.facid = b.facid
WHERE slots > 2
GROUP BY b.bookid, f.name
ORDER BY memid, starttime ASC;

-- End your answer
/*
Question 4 (20 marks):  Write an SQL query to display each member and the number of bookings they made for facility ID = 1. 
Include all members, even those who have never booked that facility.
*/-- Your answer here
WITH bookings_count AS (
    SELECT memid, COUNT(*) AS total_bookings
    FROM ba.bookings
	WHERE facid = 1
    GROUP BY memid
)
SELECT m.memid, m.firstname ||' '|| m.surname AS  member_name, 
       COALESCE(b.total_bookings, 0) AS facility1_bookings 
FROM ba.members AS m
LEFT JOIN bookings_count AS b ON b.memid = m.memid
GROUP BY m.memid, facility1_bookings
ORDER BY facility1_bookings DESC;

-- End your answer
/*
Question 5 (20 marks):   Write an SQL query to show the total number of slots booked by guests (memid = 0) for each facility.
Include the facility name and display the result in descending order of total slots used.
*/
-- Your answer here
SELECT f.facid, f.name AS facility_name, SUM(b.slots) AS total_guest_slots
FROM ba.facilities AS f
JOIN ba.bookings AS b ON f.facid = b.facid
WHERE b.memid = 0
GROUP BY f.facid
ORDER BY total_guest_slots DESC;
-- End your answer
/*
Question 6 (20 marks): Write an SQL query to rank members based on their total number of bookings. 
Members with the same number of bookings should have the same rank. Only include members who have made at least one booking
*/
-- Your answer here
WITH total_bookings_per_member AS (
  SELECT b.memid, m.firstname ||','|| m.surname AS member_name,
         COUNT(b.bookid) AS total_bookings
  FROM ba.bookings AS b
  JOIN ba.members m ON b.memid = m.memid
  GROUP BY b.memid, member_name
)
SELECT memid, member_name, total_bookings,
       RANK() OVER (ORDER BY total_bookings DESC) AS rank
FROM total_bookings_per_member;






-- End your answer
