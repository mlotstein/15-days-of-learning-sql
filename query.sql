SELECT
  c_date,
  num_hackers,
  s.hacker_id,
  s.name
FROM
  (SELECT
    c_date,
    COUNT(*) as num_hackers
  FROM
    # For each date and hacker id, determine the number of consecutive
    # days they've submitted starting from the beginning
    (SELECT
      c_date,
      hacker_id,
      COUNT(*) as days_submitted
    FROM
      # Get the set of dates in the contest
      (SELECT
        submission_date as c_date
      FROM
        Submissions
      WHERE
       submission_date >= '2016-03-01' 
       AND submission_date <= '2016-03-15'
      GROUP BY c_date) d
    JOIN
        # Collect stats on all days that hackers submitted
       (SELECT DISTINCT 
               hacker_id, 
               submission_date, 
               1 as counter
        FROM Submissions 
        WHERE 
        submission_date >= '2016-03-01') ds
     # For a given date, join against all prior days
     ON
      d.c_date >= ds.submission_date
    GROUP BY c_date, hacker_id
    # But only include hackers who have submitted every day since the start
    # which is the same as the difference between the current date and the
    # beginning of the hackathon
    HAVING days_submitted = DATEDIFF(c_date, '2016-03-01') + 1) dsc
  GROUP BY c_date) d
  JOIN
     (SELECT
        submission_date,
        h.hacker_id as hacker_id,
        h.name as name
      FROM
          (SELECT
            ms.submission_date as submission_date,
            MIN(ns.hacker_id) as hacker_id
          FROM
            (SELECT
              submission_date,
              MAX(num_submissions) as max_submissions
            FROM
              (SELECT
                submission_date,
                hacker_id,
                COUNT(submission_id) as num_submissions
              FROM
                Submissions
              GROUP BY submission_date, hacker_id) ns
            GROUP BY submission_date) ms
            JOIN
              (SELECT
                submission_date,
                hacker_id,
                COUNT(submission_id) as num_submissions
              FROM
                Submissions
              GROUP BY submission_date, hacker_id) ns
            ON ns.submission_date = ms.submission_date 
                AND ms.max_submissions = ns.num_submissions
            GROUP BY submission_date) min_h
        JOIN Hackers h on h.hacker_id = min_h.hacker_id) s
    ON s.submission_date = d.c_date
ORDER BY c_date ASC
