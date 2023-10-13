#------------createdatabase-----------------------#
CREATE DATABASE wallmart;
#--------------import table from  storage-------------------#
USE wallmart;
SELECT * FROM walmartsalesdata2;
#--------------------------------------DATA CLEANING-----------------------------------------#
#-------------drop empty column---------------------#
ALTER TABLE walmartsalesdata2
DROP COLUMN MyUnknownColumn ;
#----------now lest cheq THE TABLE -------------------------------#
SELECT * FROM walmartsalesdata2;
#--------------------------LETS SEE THERE IS ANY NULL VALUE OR NOT -----------#
SELECT * FROM walmartsalesdata2
WHERE INVOICE_ID IS NULL;
#---------------THERE IS NOT ANY NULLL VALUES-------------------#
#------------------CREATE PRIMARY KEY -------------------------#
ALTER TABLE walmart
ADD PRIMARY KEY (ID);
#-----------------------DROP DATE NEW COLUMN-----------#
ALTER TABLE walmart
DROP COLUMN DATE_NEW;
#----------------CREATE A COLUMN DATES--------------#
ALTER TABLE walmart
ADD COLUMN dates DATE;
#------------------CONVERT DATE COLUMN TYPE TO DATE TYPE---------------#
#--------------TURN OFF SAFE MODE------------------------#
SET SQL_SAFE_UPDATES=0;
# UPDATE walmart
# SET DATE=
#STR_TO_DATE(DATE,"%Y/%M/%D");
ALTER TABLE walmart 
DROP COLUMN dates;

#-----------------------DATA ENGINEERING-----------------------------------#
SELECT Time ,(
               CASE
                    WHEN Time BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
                    WHEN Time BETWEEN "12:00:01" AND "16:00:00" THEN "AFTERNOON"
                    ELSE "EVENING"
				END
                ) AS "Time_of_day"
FROM walmart;


#----------------add this column to table---------------------#
ALTER TABLE walmart
ADD COLUMN Time_of_day varchar(30);

UPDATE walmart
SET Time_OF_DAY =
                 ( CASE
                       WHEN Time BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
                       WHEN Time BETWEEN "12:00:01" AND "16:00:00" THEN "AFTERNOON"
                       ELSE "EVENING"
				  END
                  );
#-------------------NOW LETS SEE THE TABLE------------------------#
SELECT * FROM walmart;
#----------------------now see the day name of date-----------------#
USE wallmart;
select DATE , dayname(DATE) FROM walmart;
#----------------------------------------ADD COLUMNS DAY NAME----------#
ALTER TABLE walmart
ADD COLUMN day_name VARCHAR(30);
 
 #--------------------NOW ADD VALUES ON DAY COLUMN-----------------#
 SET SQL_SAFE_UPDATES=0;
 UPDATE walmart
 SET day_name = DAYNAME(DATE);

#---------------NOW AFTER ADD COLUMN OF DAY NAME LETS SEE MOTH NAME-------------------#
SELECT DATE , monthname(DATE) AS MONTH_NAME  FROM walmart; 
#---------------NOW ADD MOTH NAME COLUMN------------------#
ALTER TABLE walmart
ADD COLUMN month_name VARCHAR(20);
#------------ 2ND STEP ------------------#
UPDATE walmart
SET month_name = MONTHNAME(DATE);
#-----------------LETS CHEQ IT OUT-------------------------#
SELECT * FROM walmart; 

#----------------------------EDA----------------------------#

#--------HOW MANY CITY DOES THE DATA HAVE??--------------------#
SELECT DISTINCT City FROM walmart;

#------------HOW MANY BRANCHES ARE THERE ??-----------------#
SELECT DISTINCT Branch FROM walmart;
#----------------both question in one shot------------------#
SELECT DISTINCT City,Branch from walmart;
#--------------------HOW MANY UNIQUE PRODUCT LINE WE HAVE? -----------#
SELECT DISTINCT Product_line FROM walmart;
#----------------SO WE HAVE 6 PRODUCT LINE LEST CHEQ ITS 6 OR NOT ----------#
SELECT COUNT(DISTINCT Product_line) FROM walmart;
#-----------------------WHAT IS THE MOST COMMON PAYMENT MATHOD??----------#
SELECT 
Payment, COUNT(Payment)AS CNT 
FROM walmart 
GROUP BY Payment
ORDER BY  CNT DESC;
#---------------ANS = "EWALLET" IS MOST COMMAN PAYMENT MAYHOUD--------------#
#-----------WHAT IS THE MOST SELLING PRODUCT LINE ??-------------#
SELECT PRODUCT_LINE,COUNT(PRODUCT_LINE) AS CNT FROM walmart GROUP BY PRODUCT_LINE ORDER BY CNT ;
#------------ANS="FASHION ACCESSORIES" IS MOST SELLING PRODUCT LINE-----------#
#------------------WHAT IS THE TOTAL REVENUE BY MONTH -----------------------#
SELECT month_name, sum(total)as sum_income  from walmart  group by month_name ;
select distinct month _name from walmart;
#-------------ANS= january is the highest revenue among all moths-----------#
#--------------------WHAT MOTH HAD THE LARGEST COGS-----------------#
USE wallmart;
SELECT month_name , sum(truncate(cogs,0)) as total_cogs FROM walmart GROUP BY month_name ;
ALTER TABLE walmart
DROP COLUMN ss;
#--------------------see the table_---------------------#
SELECT * FROM walmart;

#---------------what product line had the largest revenue??-------------------#
SELECT Product_line,sum(Total) AS TOTAL_REVENUE FROM walmart GROUP BY Product_line ORDER BY TOTAL_REVENUE DESC;
#-----------------FOOD AND BEVARAGES ARE  HAD THE LARGEST REVENUE AMONG ALL-------------------#

##---------------what CITY had the largest revenue??-------------------#
SELECT Branch,City , sum(truncate(Total,0)) AS TOTAL_REVENUE FROM walmart GROUP BY Branch,City ORDER BY TOTAL_REVENUE DESC;
#-------------------------NAYPYITAW IS THE CITY WHO HAD THE LARGEST REVENUE-------------------#
#---------------what product line had the largest VAT ??-------------------#
SELECT Product_line , AVG(Tax) AS AVERAGE_TAX FROM walmart GROUP BY Product_line ORDER BY AVERAGE_TAX DESC;
USE wallmart;


#---------------WHIC BRANCH SOLD MORE PRODUCTS THAN AVERAGE PRODUCT SALES---------------------#
SELECT Branch , SUM(Quantity) AS TOTAL_QNT FROM walmart 
GROUP BY Branch HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM walmart);

#------------every branch had sold products than  AVERAGE PRODUCT SALES-----------------------#
#------------------what is the most common product line by gender-----------------------#
SELECT Gender , Product_line,COUNT(Gender) AS TOTAL_COUNT FROM walmart 
GROUP BY Gender ,Product_line ORDER BY TOTAL_COUNT DESC;
#---------------FEMALE BUYS MOSTLY FASHION ACCESSORIES AND MALE BY HEALTH AND BEAUTY PRODUCTS LINE _-------------#
#-----------------what is the average rating of product line-----------------#
SELECT Product_line , ROUND(AVG(Rating),2)AS AVERAGE FROM walmart GROUP BY Product_line ORDER BY AVERAGE DESC;
#----------------------FOOD AND BEVAERAGES IS THE HIGHEST RATING--------------------#

#-------------------SALES---------------------------------
#-------------------NUMBER OF SALES  MADE IN EACH TIME OF THE DAY PER WEEKDAY----------------------#

USE wallmart;
SELECT * FROM walmart;
SELECT Time_of_day , COUNT(*) AS TOTAL_COUNT FROM walmart WHERE day_name ="Sunday" GROUP BY Time_of_day ORDER BY TOTAL_COUNT DESC;

#------------------------------------WITHOUT DAYS----------------
SELECT Time_of_day , COUNT(*) AS TOTAL_COUNT FROM walmart GROUP BY Time_of_day ORDER BY TOTAL_COUNT DESC;
#-------------------------answer is  in evening  most of pepole buy product -----------------------#

#----------------------WHIC OF THE CUSTOMERS TYPE  BRING THE MOST REVENUE-------------#
SELECT Customer_type , ROUND(sum(Total),2) FROM walmart GROUP BY Customer_type; 
#--------------------------------GENDER WISE----------------------------#
SELECT Gender , SUM(Total) AS TOTAL FROM walmart GROUP BY Gender ORDER BY TOTAL DESC;
#-----------------FEMALE BRINGS MOST  REVENUE--------------------------#

#-----------------WHIC CITY HAS THE LARGEST TAX__---------------------#
SELECT City , AVG(Tax) AS TAX FROM walmart GROUP BY City ORDER BY  TAX DESC;

#---------------------------# 'Naypyitaw' IS THE CITY HAS LARGEST TAX---------------#


#-------------------------WHIC CUSTOMER TYPE PAY THE MOST TAX---------------# 
SELECT Customer_type , AVG(Tax) AS TAX FROM walmart GROUP BY Customer_type ORDER BY TAX DESC;
SELECT Gender , AVG(Tax) AS TAX FROM walmart GROUP BY Gender ORDER BY TAX DESC;
#------------------------------MEMBER AND FEMAL PAYS MOST TAX--------------------#

#-------------------------------CUSTOMERS-----------------
#------------------------HOW MANY UNIQUE CUSTOMER TYPE HAVE IN DATA---------------
SELECT DISTINCT(Customer_type) FROM walmart;
#---------------------MEMBER AND NORMAL IS UNIQUE TYPE OF CUSTOMERS-----------------

#------------------HOW MANY UNIQUE PAYMENT METHOD DATA HAVE??----------------
SELECT DISTINCT(Payment) FROM walmart;
#-------------we have 3 type of payment method EWALLET , CASH , CREDIT CARD---------------#

#---------------what is most common type of customer------------------#
SELECT Customer_type ,COUNT(Customer_type) FROM walmart GROUP BY Customer_type;
#------------there is very small diffrence between member and normal type customer but MEMBER I MOST COMMON TYPE---------

#----------------WHIC CUSTOMER TYPE BUYS MORE------------------------#
SELECT Customer_type , SUM(Quantity) AS  QNT FROM walmart GROUP BY Customer_type ; 
#----------------------MEMBER BUYS MORE THAN NORMAL TYPE CUSTOMERS----------------#

#---------WHAT TYPE OF  GENDER IS THE MOST IN WALLMART----------#
SELECT Gender , COUNT(Gender) FROM walmart GROUP BY Gender ;
#-----------------------FEMALE IS MOST COMMON-------------------#

#--------------------WHAT IS THE GENDER DISTRIBUTION PER BRANCH---------------#
#---------------------------------------------A----------------------------
SELECT Gender , COUNT(Gender) AS GENDER FROM WALMART WHERE Branch ="A" GROUP BY GENDER;
#---------------------------------------------B----------------------------
SELECT Gender , COUNT(Gender) AS GENDER FROM WALMART WHERE Branch ="B" GROUP BY GENDER;

#---------------------------------------------C----------------------------
SELECT Gender , COUNT(Gender) AS GENDER FROM WALMART WHERE Branch ="C" GROUP BY GENDER;

#------------------------IN WHIC TIME CUTOMERS GIVE MOST RATING---------------#
SELECT Time_of_day , COUNT(Rating) AS RATING FROM walmart GROUP BY Time_of_day ORDER BY RATING DESC;

#-------------------------IN EVENING CUSTOMERS GIVES MOST RATINGS-----------------
#------------------------IN WHIC TIME CUTOMERS GIVE MOST RATING BY BRANCH---------------#
#-----------------------------------------------A-----------------------------
SELECT Time_of_day , ROUND(AVG(Rating),2) AS RATING FROM walmart  WHERE Branch = "A" GROUP BY Time_of_day ORDER BY RATING DESC;
#-----------------------------------------------B-----------------------------
SELECT Time_of_day , ROUND(AVG(Rating),2) AS RATING FROM walmart  WHERE Branch = "B" GROUP BY Time_of_day ORDER BY RATING DESC;

#-----------------------------------------------C-----------------------------
SELECT Time_of_day , ROUND(AVG(Rating),2) AS RATING FROM walmart  WHERE Branch = "C" GROUP BY Time_of_day ORDER BY RATING DESC;

#---------------------------WHIC DAY CUSTOMERS GIVE MOST RATING--------------------#
SELECT day_name , COUNT(Rating) AS RATING FROM walmart GROUP BY day_name ORDER BY RATING DESC;

#-------------------- IN SUNDAY CUSTOMERS GIVES MOST RATINGS----------------
#-------------------WHIC DAY OF WEEK HAS THE BEST AVG RATINGS-------------------#
SELECT day_name , ROUND(AVG(Rating),2) AS RATING
FROM walmart GROUP BY day_name ORDER BY RATING DESC;

#-------------------WHIC DAY OF WEEK HAS THE BEST AVG RATINGS-------------------#
#------------------------------------------------A------------------------------
SELECT day_name , ROUND(AVG(Rating),2) AS RATING FROM walmart  WHERE Branch="A"  GROUP BY day_name ORDER BY RATING DESC ;
#------------------------------------------------B------------------------------#
SELECT 
    day_name, ROUND(AVG(Rating), 2) AS RATING
FROM
    walmart
WHERE
    Branch = 'B'
GROUP BY day_name
ORDER BY RATING DESC;
##------------------------------------------------B------------------------------#
SELECT day_name , ROUND(AVG(Rating),2) AS RATING FROM walmart  WHERE Branch="A"  GROUP BY day_name ORDER BY RATING DESC ;
#------------------------------------------------B------------------------------#
SELECT 
    day_name, ROUND(AVG(Rating), 2) AS RATING
FROM
    walmart
WHERE
    Branch = 'C'
GROUP BY day_name
ORDER BY RATING DESC;
