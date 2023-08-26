Select *
From bloodtypes$

Delete From bloodtypes$ where Country = 'World'

--Which country has the highest percentage of population with blood type A+?

SELECT Country
From bloodtypes$
Where [A+] = (Select MAX([A+]) FROM bloodtypes$);

--In how many countries is the percentage of O- blood type less than 5%?

SELECT Count(*) AS countriesOnegative
FROM bloodtypes$
WHERE [O-] <5.0



--Which two blood types is the highest combined percentage in United States?


SELECT Country,
       BloodType,
       Percentage
FROM (
    SELECT Country,
           'O+' AS BloodType,
           [O+] AS Percentage,
           ROW_NUMBER() OVER (ORDER BY [O+] DESC) AS rn
    FROM bloodtypes$ 
    WHERE Country = 'United States'
    
    UNION ALL
    
    SELECT Country,
           'A+' AS BloodType,
           [A+] AS Percentage,
           ROW_NUMBER() OVER (ORDER BY [A+] DESC) AS rn
    FROM bloodtypes$ 
    WHERE Country = 'United States'
    
    UNION ALL
    
    SELECT Country,
           'B+' AS BloodType,
           [B+] AS Percentage,
           ROW_NUMBER() OVER (ORDER BY [B+] DESC) AS rn
    FROM bloodtypes$ 
    WHERE Country = 'United States'
    
    UNION ALL
    
    SELECT Country,
           'AB+' AS BloodType,
           [AB+] AS Percentage,
           ROW_NUMBER() OVER (ORDER BY [AB+] DESC) AS rn
    FROM bloodtypes$
    WHERE Country = 'United States'
) AS CombinedPercentages
WHERE rn <= 2;


--Calculate the total amount of people with blood types in all the countries combined

SELECT 
    ROUND(SUM(Population * ([O+] / 100)),0) AS Total_Oplus,
    ROUND(SUM(Population * ([A+] / 100)),0) AS Total_Aplus,
    ROUND(SUM(Population * ([B+] / 100)),0) AS Total_Bplus,
    ROUND(SUM(Population * ([AB+] / 100)),0) AS Total_ABplus,
    ROUND(SUM(Population * ([O-] / 100)),0) AS Total_Ominus,
    ROUND(SUM(Population * ([A-] / 100)),0) AS Total_Aminus,
    ROUND(SUM(Population * ([B-] / 100)),0) AS Total_Bminus,
    ROUND(SUM(Population * ([AB-] / 100)),0) AS Total_ABminus
FROM bloodtypes$;


--Calculate the average percentage of each blood type across all countries

SELECT Country,
		AVG([O+]) AS average_Oplus,
		AVG([O-]) AS average_Onegative,
		AVG([A+])  AS average_Aplus,
		AVG([A-])  AS average_Anegative,
		AVG([B+])  AS average_Bplus,
		AVG([B-])  AS average_Bnegative,
		AVG([AB+]) AS average_ABplus,
		AVG([AB-]) AS average_ABnegative
FROM bloodtypes$
Group by Country


--Overall percentage of blood type across the world

SELECT 
    (SUM(Population * [O+]) + SUM(Population * [A+]) + SUM(Population * [B+]) + SUM(Population * [AB+])) / SUM(Population) AS Overall_Oplus,
    (SUM(Population * [A+]) + SUM(Population * [A-]) + SUM(Population * [AB+]) + SUM(Population * [AB-])) / SUM(Population) AS Overall_Aplus,
    (SUM(Population * [B+]) + SUM(Population * [B-]) + SUM(Population * [AB+]) + SUM(Population * [AB-])) / SUM(Population) AS Overall_Bplus,
    (SUM(Population * [AB+]) + SUM(Population * [AB-])) / SUM(Population) AS Overall_ABplus,
    (SUM(Population * [O-]) + SUM(Population * [A-]) + SUM(Population * [B-]) + SUM(Population * [AB-])) / SUM(Population) AS Overall_Ominus,
    (SUM(Population * [A-])) / SUM(Population) AS Overall_Aminus,
    (SUM(Population * [B-])) / SUM(Population) AS Overall_Bminus,
    (SUM(Population * [AB-])) / SUM(Population) AS Overall_ABminus
FROM bloodtypes$; 

--Ranking them



SELECT
	RANK() OVER (ORDER BY OverallPercentage DESC) AS Ranking,
    BloodType,
    Round(OverallPercentage,2) AS OverallPercentage
    
FROM (
    SELECT 
        'O+' AS BloodType,
        (SUM(Population * [O+]) + SUM(Population * [A+]) + SUM(Population * [B+]) + SUM(Population * [AB+])) / SUM(Population) AS OverallPercentage
    FROM bloodtypes$ 

    UNION ALL

    SELECT 
        'A+' AS BloodType,
        (SUM(Population * [A+]) + SUM(Population * [A-]) + SUM(Population * [AB+]) + SUM(Population * [AB-])) / SUM(Population) AS OverallPercentage
    FROM bloodtypes$

    UNION ALL

    SELECT 
        'B+' AS BloodType,
        (SUM(Population * [B+]) + SUM(Population * [B-]) + SUM(Population * [AB+]) + SUM(Population * [AB-])) / SUM(Population) AS OverallPercentage
    FROM bloodtypes$

    UNION ALL

    SELECT 
        'AB+' AS BloodType,
        (SUM(Population * [AB+]) + SUM(Population * [AB-])) / SUM(Population) AS OverallPercentage
    FROM bloodtypes$

    UNION ALL

    SELECT 
        'O-' AS BloodType,
        (SUM(Population * [O-]) + SUM(Population * [A-]) + SUM(Population * [B-]) + SUM(Population * [AB-])) / SUM(Population) AS OverallPercentage
    FROM bloodtypes$

    UNION ALL

    SELECT 
        'A-' AS BloodType,
        (SUM(Population * [A-])) / SUM(Population)  AS OverallPercentage
    FROM bloodtypes$

    UNION ALL

    SELECT 
        'B-' AS BloodType,
        (SUM(Population * [B-])) / SUM(Population) AS OverallPercentage
    FROM bloodtypes$

    UNION ALL

    SELECT 
        'AB-' AS BloodType,
        (SUM(Population * [AB-])) / SUM(Population) AS OverallPercentage
    FROM bloodtypes$
) AS BloodTypeData;



