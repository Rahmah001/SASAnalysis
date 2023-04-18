
/* Compute the correlation matrix */
proc corr data=work.bankchurners out=corr_matrix noprint;
var _numeric_;
run;

proc sort data=WORK.CORR_MATRIX;
by _NAME_;
run;

/* Transpose the correlation matrix for plotting */
proc transpose data=WORK.corr_matrix out=corr_matrix_transposed;
by _name_;
run;

/* Create the heatmap plot */
proc sgplot data=work.corr_matrix_transposed;
    band x=_name_ y=_name_ lower=col1 upper=col2 / colormap=heatmap;
    xaxis display=none;
    yaxis display=none;
    title "Correlation Matrix";
run;

ods graphics / width=640 height=400px;
title "Continuous Heat Map";
title2 "Continuous Color Ramp and Legend";
proc sgplot data=work.bankchurners;
   heatmapparm x=Dependent_count y=Customer_age colorresponse=MOnths_on_book / outline discretex;
   text x=Dependent_count y=Customer_age text=MOnths_on_book / textattrs=(size=12pt) strip;
   gradlegend;
run;

/*ods graphics / width=640 height=400px;
title "Continuous Heat Map";
title2 "Continuous Color Ramp and Legend";
proc sgplot data=Sales;
   heatmapparm x=Week y=Product colorresponse=QtySold / outline discretex;
   text x=Week y=Product text=QtySold / textattrs=(size=12pt) strip;
   gradlegend;
run;
*/

/*Decision Tree sample 
proc kpca data=work.bankchurners method=approximate;
   input Avg_Open_To_Buy Avg_Utilization_Ratio Total_Trans_Amt;
   lrapproximation clusmethod=kmpp maxclus=500;
   kernel  RBF / BW=RANDOMCMSE(SEED=2378);
   output out=scored_CMSE_fast copyvar=Customer_Age npc=3;
run;
*/
DATA new; set work.bankchurners;
PROC SORT; BY clientnum;
ods graphics on;
proc hpsplit seed=15531;
class Customer_age gender Attrition_flag Credit_Limit card_category Dependent_count Contacts_Count_12_mon
   Education_Level Income_category ;
model customer_age=customer_age gender Attrition_flag Credit_Limit card_category Dependent_count Contacts_Count_12_mon Education_Level Income_category
 
;
prune costcomplexity;
  
RUN;
