data work.bankchurners;
set work.bankchurners;
   infile '/home/u63286946/Assessment/BankChurners.csv';
  run;
  
  PROC IMPORT OUT= work.bankchurners
   DATAFILE="/home/u63286946/Assessment/BankChurners.csv"
   DBMS=CSV REPLACE;
   GETNAMES=YES;
RUN;

PROC PRINT DATA=work.bankchurners (OBS=5);
RUN;

/*get full information about the data*/

PROC CONTENTS DATA=work.bankchurners;
RUN;

/*get summary about the data*/

PROC MEANS DATA=work.bankchurners NOPRINT;
VAR _NUMERIC_;
OUTPUT OUT=work.bankchurners_summary
MEAN= / AUTONAME;
RUN;


/* Create a box plot of customer ages */
proc sgplot data=work.bankchurners;
  vbox Customer_Age / name='Age Box Plot';
  title 'Distribution of Customer Ages';
run;

/* Create a histogram of customer ages */
proc sgplot data=work.bankchurners;
  histogram Customer_Age / name='Age Histogram' binwidth=5;
  title 'Distribution of Customer Ages';
run;



/* Assuming the data set is named "data" and the target column is named "Exited" */

/* Get frequency distribution of the target column */
proc freq data=work.bankchurners;
    tables Gender / out=freq_table;
run;

/* Create a pie chart */
proc gchart data=freq_table;
    piechart Gender / percent sumvar=count slice=inside 
                     sliceaggregates=none start=270 rotate=90 
                     legend=legend1 cfill=red bfill=blue;
    title 'Target column Distribution';
run;

PROC TEMPLATE;
   DEFINE STATGRAPH piegender;
      BEGINGRAPH;
         LAYOUT REGION;
            PIECHART CATEGORY = Gender /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT=ALL
            DATASKIN=gloss
            CATEGORYDIRECTION = CLOCKWISE
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Customer by Gender';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC TEMPLATE;
   DEFINE STATGRAPH piecardcat;
      BEGINGRAPH;
         LAYOUT REGION;
            PIECHART CATEGORY = Card_Category /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT=ALL
            DATASKIN=gloss
            CATEGORYDIRECTION = CLOCKWISE
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Customer by Card Category';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC TEMPLATE;
   DEFINE STATGRAPH piegmaritalstatus;
      BEGINGRAPH;
         LAYOUT REGION;
            PIECHART CATEGORY = Marital_Status /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT=ALL
            DATASKIN=gloss
            CATEGORYDIRECTION = CLOCKWISE
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Customer by Marital Status';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC TEMPLATE;
   DEFINE STATGRAPH pieeducationlevel;
      BEGINGRAPH;
         LAYOUT REGION;
            PIECHART CATEGORY = Education_Level /
            DATALABELLOCATION = INSIDE
            DATALABELCONTENT=ALL
            DATASKIN=gloss
            CATEGORYDIRECTION = CLOCKWISE
            START = 180 NAME = 'pie';
            DISCRETELEGEND 'pie' /
            TITLE = 'Customer by Educational level';
         ENDLAYOUT;
      ENDGRAPH;
   END;
RUN;
PROC SGRENDER DATA = work.bankchurners
            TEMPLATE = piegender;
RUN;

PROC SGRENDER DATA = work.bankchurners
            TEMPLATE = piegmaritalstatus;
RUN;


PROC SGRENDER DATA = work.bankchurners
            TEMPLATE = piecardcat;
RUN;

PROC SGRENDER DATA = work.bankchurners
            TEMPLATE = pieeducationlevel;
RUN;


proc sgscatter data = work.bankchurners; 
compare y = Total_Trans_Amt  x = (Contacts_Count_12_mon)  
         / group = Income_Category  ellipse =(alpha = 0.05 type = predicted); 
title
'Average Total Transaction Amount vs. Contacts_Count_12_mon '; 
title2
'-- with 95% prediction ellipse --'
; 
format

run;

/*  CORRELATION */
/* Replace Attrition_Flag values with binary values */
data work.bankchurners;
    set work.bankchurners;
    if Attrition_Flag = 'Attrited Customer' then Attrition_Flag = 1;
    else if Attrition_Flag = 'Existing Customer' then Attrition_Flag = 0;
run;

/* Replace Gender values with binary values */
data work.bankchurners;
    set work.bankchurners;
    if Gender = 'F' then Gender = 1;
    else if Gender = 'M' then Gender = 0;
run;

/* Create dummy variables for Education_Level */
proc sql noprint;
    create table education_dummies as
    select CLIENTNUM,
           case when Education_Level = 'Uneducated' then 1 else 0 end as Uneducated,
           case when Education_Level = 'High School' then 1 else 0 end as High_School,
           case when Education_Level = 'College' then 1 else 0 end as College,
           case when Education_Level = 'Graduate' then 1 else 0 end as Graduate,
           case when Education_Level = 'Post-Graduate' then 1 else 0 end as Post_Graduate,
           case when Education_Level = 'Doctorate' then 1 else 0 end as Doctorate
    from work.bankchurners;
quit;

/* Create dummy variables for Income_Category */
proc sql noprint;
    create table income_dummies as
    select CLIENTNUM,
           case when Income_Category = '$40K - $60K' then 1 else 0 end as Income_40K_60K,
           case when Income_Category = '$60K - $80K' then 1 else 0 end as Income_60K_80K,
           case when Income_Category = '$80K - $120K' then 1 else 0 end as Income_80K_120K,
           case when Income_Category = '$120K +' then 1 else 0 end as Income_120K_plus
    from work.bankchurners;
quit;

/* Create dummy variables for Marital_Status */
proc sql noprint;
    create table marital_dummies as
    select CLIENTNUM,
           case when Marital_Status = 'Single' then 1 else 0 end as Single,
           case when Marital_Status = 'Married' then 1 else 0 end as Married,
           case when Marital_Status = 'Divorced' then 1 else 0 end as Divorced
    from work.bankchurners;
quit;

/* Create dummy variables for Card_Category */
proc sql noprint;
    create table card_dummies as
    select CLIENTNUM,
           case when Card_Category = 'Blue' then 1 else 0 end as Card_Blue,
           case when Card_Category = 'Silver' then 1 else 0 end as Card_Silver,
           case when Card_Category = 'Gold' then 1 else 0 end as Card_Gold
    from work.bankchurners;
quit;

/* Join the dummy variables to the original dataset and drop unnecessary columns */
proc sql noprint;
    create table work.bankchurners_new as
    select a.*, 
           b.Uneducated, b.High_School, b.College, b.Graduate, b.Post_Graduate, b.Doctorate,
           c.Income_40K_60K, c.Income_60K_80K, c.Income_80K_120K, c.Income_120K_plus,
           d.Single, d.Married, d.Divorced,
           e.Card_Blue, e.Card_Silver, e.Card_Gold
    from work.bankchurners as a
    left join education_dummies as

