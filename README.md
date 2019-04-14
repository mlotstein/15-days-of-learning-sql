# 15-days-of-learning-sql
[HackerRank Hard SQL Problem](https://www.hackerrank.com/challenges/15-days-of-learning-sql)

From the linked page:
>Julia conducted a 15 days of learning SQL contest. The start date of the contest was March 01, 2016 and the end date was March 15, 2016.

>Write a query to print total number of unique hackers who made at least 1  submission each day (starting on the first day of the contest), and find the hacker_id and name of the hacker who made maximum number of submissions each day. If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.

This is actually quite confusing. I found a [user's description](https://www.hackerrank.com/challenges/15-days-of-learning-sql/forum/comments/202102) of the problem much clearer:
>Write a query to print total number of unique hackers who made at least submission each day (starting on the first day of the contest) *until that day* and find the hacker_id and name of the hacker who made maximum number of submissions each day *(without considering if they made submissions the days before or after)*. If more than one such hacker has a maximum number of submissions, print the lowest hacker_id. The query should print this information for each day of the contest, sorted by the date.

Unfortunately, the version of MySQL that HackerRank accepts doesn't support CTEs, so there's quite a bit of redundancy in the code. High-level architecture is:
SELECT
  date,
  number_of_hackers_who've_submitted_every_day_until_now,
  hacker_id_who_submitted_most_on_this_day,
  that_hacker's_name
FROM
  (table of date, number_of_hackers_who_submitted_everyday_until_that_date)
  JOIN
  (table of date, hacker_id_who_submitted_most_on_that_date, that_hacker's_name)
  ON
  date
  
The most interesting part of the query is the first sub-query, where I use a non-equijoin and a clever HAVING clause, to filter only hackers who have made submissions every day of the hackathon until that point in time.
