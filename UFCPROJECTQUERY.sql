-- Testing the Dataset
SELECT B_avg_SIG_STR_pct, R_avg_SIG_STR_pct
FROM UFCPROJECT..newdata;

SELECT * 
FROM UFCPROJECT..preprocessed_data;

SELECT R_fighter, B_fighter, Winner
FROM UFCPROJECT..newdata
WHERE Location ='Las Vegas, Nevada, Usa';

-- Deleting the columns which have NULL significant strikes 

DELETE FROM UFCPROJECT..newdata WHERE B_avg_SIG_STR_pct IS NULL AND R_avg_SIG_STR_pct IS NULL;
DELETE FROM UFCPROJECT..newdata WHERE B_avg_SIG_STR_pct IS NULL OR R_avg_SIG_STR_pct IS NULL;

-- Likelihood of more percentage of significant strikes and wins
SELECT R_fighter, B_fighter, ROUND(R_avg_SIG_STR_pct,2) AS PercenatageOfSignificantStrikes_Red, 
	   ROUND(B_avg_SIG_STR_pct,2) AS PercenatageOfSignificantStrikes_Blue,
	CASE WHEN B_avg_SIG_STR_pct > R_avg_SIG_STR_pct AND Winner = 'RED' THEN 'Less Significant Strikes Landed and Won'
		 WHEN B_avg_SIG_STR_pct < R_avg_SIG_STR_pct AND Winner = 'BLUE' THEN 'Less Significant Strikes Landed and Won'
		 WHEN B_avg_SIG_STR_pct > R_avg_SIG_STR_pct AND Winner = 'BLUE' THEN 'More Significant Strikes Landed and Won'
		 WHEN B_avg_SIG_STR_pct < R_avg_SIG_STR_pct AND Winner = 'RED' THEN 'More Significant Strikes Landed and Won'
		 ELSE 'Niether' END AS Cases
FROM UFCPROJECT..newdata
WHERE B_age>R_AGE 
ORDER BY Cases;

-- CTE on previous Query
WITH SigstrikexWins (Red, Blue, PercenatageOfSignificantStrikes_Red, PercenatageOfSignificantStrikes_Blue, Cases) AS
(SELECT R_fighter, B_fighter, ROUND(R_avg_SIG_STR_pct,2) AS PercenatageOfSignificantStrikes_Red, 
	   ROUND(B_avg_SIG_STR_pct,2) AS PercenatageOfSignificantStrikes_Blue,
	CASE WHEN B_avg_SIG_STR_pct > R_avg_SIG_STR_pct AND Winner = 'RED' THEN 'Less Significant Strikes Landed and Won'
		 WHEN B_avg_SIG_STR_pct < R_avg_SIG_STR_pct AND Winner = 'BLUE' THEN 'Less Significant Strikes Landed and Won'
		 WHEN B_avg_SIG_STR_pct > R_avg_SIG_STR_pct AND Winner = 'BLUE' THEN 'More Significant Strikes Landed and Won'
		 WHEN B_avg_SIG_STR_pct < R_avg_SIG_STR_pct AND Winner = 'RED' THEN 'More Significant Strikes Landed and Won'
		 ELSE 'Niether' END AS Cases	
FROM UFCPROJECT..newdata)
--ORDER BY Cases
SELECT Count(*) As NofCases, Cases
FROM SigstrikexWins
GROUP BY Cases
ORDER BY NofCases DESC;

-- Does Age matter?
SELECT Winner, R_age, B_age,
	   CASE WHEN R_age > B_age AND Winner = 'Red' THEN 'Case 1'
		    WHEN R_age > B_age AND Winner = 'Blue' THEN 'Case 2'
			WHEN R_age < B_age AND Winner = 'Red' THEN 'Case 2'
			WHEN R_age < B_age AND Winner = 'Blue' THEN 'Case 1'
			ELSE 'Case 3' END AS Num 
FROM UFCPROJECT..newdata;


-- CTE IN Age Analysis?
WITH Cont (Winner, R_age, B_age, Casesofwin) AS
(
SELECT Winner, R_age, B_age,
	    CASE WHEN R_age > B_age AND Winner = 'Red' THEN 'Case 1'
		    WHEN R_age > B_age AND Winner = 'Blue' THEN 'Case 2'
			WHEN R_age < B_age AND Winner = 'Red' THEN 'Case 2'
			WHEN R_age < B_age AND Winner = 'Blue' THEN 'Case 1'
			ELSE 'Case 3' END AS Casesofwin
FROM UFCPROJECT..newdata)
SELECT Casesofwin, Count (*) AS Countofwins
FROM Cont
GROUP by Casesofwin
ORDER BY Countofwins DESC;


