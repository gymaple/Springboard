/* I downloaded the tables and run the following queries using MYSQL 
on my own laptop */

/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
SELECT name,
		membercost
	FROM facilities
	WHERE membercost != 0
	;
/*
+----------------+------------+
| name           | membercost |
+----------------+------------+
| Tennis Court 1 |        5.0 |
| Tennis Court 2 |        5.0 |
| Massage Room 1 |        9.9 |
| Massage Room 2 |        9.9 |
| Squash Court   |        3.5 |
+----------------+------------+
5 rows in set (0.00 sec)
*/

/* Q2: How many facilities do not charge a fee to members? */
SELECT 
	COUNT(*) AS Num_NOfee_member
	FROM facilities
	WHERE membercost != 0
	;
/*
+------------------+
| Num_NOfee_member |
+------------------+
|                5 |
+------------------+
1 row in set (0.00 sec)
*/

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid,
		name,
		membercost,
		monthlymaintenance
	FROM facilities
	WHERE membercost != 0 AND membercost < monthlymaintenance * 0.2
	;

/*
+-------+----------------+------------+--------------------+
| facid | name           | membercost | monthlymaintenance |
+-------+----------------+------------+--------------------+
|     0 | Tennis Court 1 |        5.0 |                200 |
|     1 | Tennis Court 2 |        5.0 |                200 |
|     4 | Massage Room 1 |        9.9 |               3000 |
|     5 | Massage Room 2 |        9.9 |               3000 |
|     6 | Squash Court   |        3.5 |                 80 |
+-------+----------------+------------+--------------------+
5 rows in set (0.00 sec)
*/
/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT *
	FROM facilities
	WHERE facid in (1, 5);
/*
+-------+----------------+------------+-----------+---------------+--------------------+
| facid | name           | membercost | guestcost | initialoutlay | monthlymaintenance |
+-------+----------------+------------+-----------+---------------+--------------------+
|     1 | Tennis Court 2 |        5.0 |      25.0 |          8000 |                200 |
|     5 | Massage Room 2 |        9.9 |      80.0 |          4000 |               3000 |
+-------+----------------+------------+-----------+---------------+--------------------+
2 rows in set (0.00 sec)
*/
/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT
	name,
	monthlymaintenance,
	CASE WHEN monthlymaintenance > 100 THEN 'expensive' ELSE 'cheap' END AS label
	FROM facilities
	;
/*
+-----------------+--------------------+-----------+
| name            | monthlymaintenance | label     |
+-----------------+--------------------+-----------+
| Tennis Court 1  |                200 | expensive |
| Tennis Court 2  |                200 | expensive |
| Badminton Court |                 50 | cheap     |
| Table Tennis    |                 10 | cheap     |
| Massage Room 1  |               3000 | expensive |
| Massage Room 2  |               3000 | expensive |
| Squash Court    |                 80 | cheap     |
| Snooker Table   |                 15 | cheap     |
| Pool Table      |                 15 | cheap     |
+-----------------+--------------------+-----------+
9 rows in set (0.00 sec)
*/

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT a.firstname,
		a.surname,
		a.joindate
	FROM members a
	JOIN (
		SELECT max(joindate) AS last
		FROM members) b
	ON a.joindate = b.last;
/*	
+-----------+---------+---------------------+
| firstname | surname | joindate            |
+-----------+---------+---------------------+
| Darren    | Smith   | 2012-09-26 18:08:45 |
+-----------+---------+---------------------+
1 row in set (0.00 sec)
*/

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT
	DISTINCT  c.surname, c.firstname, b.name
	FROM bookings a
	LEFT JOIN facilities b
	ON a.facid = b.facid
	AND b.name like 'Tennis%'
	LEFT JOIN members c
	ON a.memid = c. memid
	AND c.memid != 0
	WHERE b.name IS NOT NULL AND c.surname IS NOT NULL AND c.firstname is not NULL
	ORDER BY 1,2
	;
/*
+----------+-----------+----------------+
| surname  | firstname | name           |
+----------+-----------+----------------+
| Bader    | Florence  | Tennis Court 2 |
| Bader    | Florence  | Tennis Court 1 |
| Baker    | Anne      | Tennis Court 1 |
| Baker    | Anne      | Tennis Court 2 |
| Baker    | Timothy   | Tennis Court 2 |
| Baker    | Timothy   | Tennis Court 1 |
| Boothe   | Tim       | Tennis Court 2 |
| Boothe   | Tim       | Tennis Court 1 |
| Butters  | Gerald    | Tennis Court 2 |
| Butters  | Gerald    | Tennis Court 1 |
| Coplin   | Joan      | Tennis Court 1 |
| Crumpet  | Erica     | Tennis Court 1 |
| Dare     | Nancy     | Tennis Court 2 |
| Dare     | Nancy     | Tennis Court 1 |
| Farrell  | David     | Tennis Court 2 |
| Farrell  | David     | Tennis Court 1 |
| Farrell  | Jemima    | Tennis Court 1 |
| Farrell  | Jemima    | Tennis Court 2 |
| Genting  | Matthew   | Tennis Court 1 |
| Hunt     | John      | Tennis Court 1 |
| Hunt     | John      | Tennis Court 2 |
| Jones    | David     | Tennis Court 2 |
| Jones    | David     | Tennis Court 1 |
| Jones    | Douglas   | Tennis Court 1 |
| Joplette | Janice    | Tennis Court 1 |
| Joplette | Janice    | Tennis Court 2 |
| Owen     | Charles   | Tennis Court 1 |
| Owen     | Charles   | Tennis Court 2 |
| Pinker   | David     | Tennis Court 1 |
| Purview  | Millicent | Tennis Court 2 |
| Rownam   | Tim       | Tennis Court 2 |
| Rownam   | Tim       | Tennis Court 1 |
| Rumney   | Henrietta | Tennis Court 2 |
| Sarwin   | Ramnaresh | Tennis Court 1 |
| Sarwin   | Ramnaresh | Tennis Court 2 |
| Smith    | Darren    | Tennis Court 2 |
| Smith    | Jack      | Tennis Court 2 |
| Smith    | Jack      | Tennis Court 1 |
| Smith    | Tracy     | Tennis Court 2 |
| Smith    | Tracy     | Tennis Court 1 |
| Stibbons | Ponder    | Tennis Court 2 |
| Stibbons | Ponder    | Tennis Court 1 |
| Tracy    | Burton    | Tennis Court 2 |
| Tracy    | Burton    | Tennis Court 1 |
+----------+-----------+----------------+
44 rows in set (0.01 sec)
*/
/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT 
	    b.name, 
	    CONCAT(c.firstname,' ', c.surname) as memname,
	    CASE WHEN c.memid = 0 THEN slots*guestcost ELSE slots*membercost END 
	    AS totalcost
		from bookings a
		JOIN facilities b
		ON a.facid = b.facid
		AND a.starttime like '2012-09-14%'
		JOIN members c
		ON a.memid = c.memid
		WHERE (CASE WHEN c.memid = 0 THEN slots*guestcost ELSE slots*membercost END ) > 30
		ORDER BY 3 DESC;
/*
+----------------+----------------+-----------+
| name           | memname        | totalcost |
+----------------+----------------+-----------+
| Massage Room 2 | GUEST GUEST    |     320.0 |
| Massage Room 1 | GUEST GUEST    |     160.0 |
| Massage Room 1 | GUEST GUEST    |     160.0 |
| Massage Room 1 | GUEST GUEST    |     160.0 |
| Tennis Court 2 | GUEST GUEST    |     150.0 |
| Tennis Court 1 | GUEST GUEST    |      75.0 |
| Tennis Court 1 | GUEST GUEST    |      75.0 |
| Tennis Court 2 | GUEST GUEST    |      75.0 |
| Squash Court   | GUEST GUEST    |      70.0 |
| Massage Room 1 | Jemima Farrell |      39.6 |
| Squash Court   | GUEST GUEST    |      35.0 |
| Squash Court   | GUEST GUEST    |      35.0 |
+----------------+----------------+-----------+
12 rows in set (0.00 sec)
*/
/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT
		name,
		memname,
		totalcost
FROM 
	(SELECT 
	    a.facid, a.memid, a.starttime, a.slots, b.name, b.membercost, b.guestcost, 
	    CONCAT(c.firstname,' ', c.surname) as memname,
	    CASE WHEN c.memid = 0 THEN slots*guestcost ELSE slots*membercost END 
	    AS totalcost
		from bookings a
		JOIN facilities b
		ON a.facid = b.facid
		AND a.starttime like '2012-09-14%'
		JOIN members c
		ON a.memid = c.memid) tmp
WHERE totalcost > 30
ORDER BY totalcost DESC
;
/*
+----------------+----------------+-----------+
| name           | memname        | totalcost |
+----------------+----------------+-----------+
| Massage Room 2 | GUEST GUEST    |     320.0 |
| Massage Room 1 | GUEST GUEST    |     160.0 |
| Massage Room 1 | GUEST GUEST    |     160.0 |
| Massage Room 1 | GUEST GUEST    |     160.0 |
| Tennis Court 2 | GUEST GUEST    |     150.0 |
| Tennis Court 1 | GUEST GUEST    |      75.0 |
| Tennis Court 1 | GUEST GUEST    |      75.0 |
| Tennis Court 2 | GUEST GUEST    |      75.0 |
| Squash Court   | GUEST GUEST    |      70.0 |
| Massage Room 1 | Jemima Farrell |      39.6 |
| Squash Court   | GUEST GUEST    |      35.0 |
| Squash Court   | GUEST GUEST    |      35.0 |
+----------------+----------------+-----------+
12 rows in set (0.01 sec)
*/
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */
select DISTINCT LEFT(starttime, 4) from bookings;
select DISTINCT RIGHT(LEFT(starttime,7), 2) from bookings;
select DISTINCT RIGHT(LEFT(joindate,7), 2) from members;
select DISTINCT LEFT(joindate, 4) from members;

/* The results showed that all bookings and members joining occurs in 
July, August, Sepember of 2012. The avenue equals sales + member fees. */
/*
+--------------------+
| LEFT(starttime, 4) |
+--------------------+
| 2012               |
+--------------------+
1 row in set (0.01 sec)
*/

/*
+-----------------------------+
| RIGHT(LEFT(starttime,7), 2) |
+-----------------------------+
| 07                          |
| 08                          |
| 09                          |
+-----------------------------+
3 rows in set (0.00 sec)
*/


SELECT 
	    b.name, 
	    SUM(CASE WHEN c.memid = 0 THEN slots*guestcost ELSE slots*membercost+initialoutlay END)
	    AS revenue
		from bookings a
		JOIN facilities b
		ON a.facid = b.facid
		JOIN members c
		ON a.memid = c.memid
	GROUP BY 1
	ORDER BY 2 DESC;
/*
+-----------------+-----------+
| name            | revenue   |
+-----------------+-----------+
| Tennis Court 1  | 3093860.0 |
| Tennis Court 2  | 2222310.0 |
| Massage Room 1  | 1734351.6 |
| Badminton Court | 1377906.5 |
| Squash Court    |  988468.0 |
| Pool Table      |  313470.0 |
| Snooker Table   |  189690.0 |
| Table Tennis    |  123380.0 |
| Massage Room 2  |  122454.6 |
+-----------------+-----------+
9 rows in set (0.01 sec)
*/