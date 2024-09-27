create database churndatabase;
use churndatabase;

select * from `ibm telco customer churn dataset_for_import - dataset_for_import`;

-- Considering the top 5 groups with the highest average monthly charges among churned customers, how can personalized offers be tailored based on age,gender, and contract type 
-- to potentially improve customer retention rates?
SELECT 
   CASE 
      WHEN Age < 30 THEN 'Young Adults'
      WHEN Age >= 30 AND Age < 50 THEN 'Middle-Aged Adults'
      ELSE 'Seniors'
   END AS AgeGroup,
   Contract,
   Gender,
   ROUND(AVG(`Tenure in Months`),2) AS AvgTenure,
   ROUND(AVG(`Monthly Charge`),2) AS AvgMonthlyCharge
FROM `ibm telco customer churn dataset_for_import - dataset_for_import`
WHERE `Churn Label` LIKE '%Yes%'
GROUP BY AgeGroup, `Customer Status`, Contract, Gender
ORDER BY AvgMonthlyCharge DESC
LIMIT 5;


-- What are the feedback or complaints from those churned customers

SELECT `Churn Category`, COUNT(`Customer ID`) AS churn_count
FROM `ibm telco customer churn dataset_for_import - dataset_for_import`
WHERE `Churn Label` LIKE "%Yes%"
GROUP BY `Churn Category`
ORDER BY churn_count DESC;


 -- How does the payment method influence churn behavior?
WITH ChurnData AS (
    SELECT `Payment Method`, COUNT(`Customer ID`) AS Churned
    FROM `ibm telco customer churn dataset_for_import - dataset_for_import`
    WHERE `Churn Label` LIKE '%Yes%'
    GROUP BY `Payment Method`),
LoyalData AS (
    SELECT  `Payment Method`, COUNT(`Customer ID`) AS Loyal
    FROM `ibm telco customer churn dataset_for_import - dataset_for_import`
    WHERE `Churn Label` LIKE '%No%'
    GROUP BY `Payment Method`)
    
SELECT 
    a.`Payment Method`, a.Churned, b.Loyal, 
    a.Churned + b.Loyal AS total, 
    SUM(a.Churned + b.Loyal) OVER (ORDER BY a.`Payment Method`) AS running_total
FROM ChurnData a 
INNER JOIN LoyalData b
ON a.`Payment Method` = b.`Payment Method`;

