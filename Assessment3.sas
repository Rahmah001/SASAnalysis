/* linear Modelling*/
proc reg data=WORK.BANKCHURNERS;
    model Dependent_Count=customer_age;
run;

/*linear regression */
ods noproctitle;
ods graphics / imagemap=on;

proc glmselect data=WORK.BANKCHURNERS outdesign(addinputvars)=Work.reg_design;
	class Customer_Age / param=glm;
	model Dependent_count=Customer_Age / showpvalues selection=none;
run;

proc reg data=Work.reg_design alpha=0.05 plots(only)=(diagnostics residuals 
		observedbypredicted);
	where Customer_Age is not missing;
	ods select DiagnosticsPanel ResidualPlot ObservedByPredicted;
	model Dependent_count=&_GLSMOD /;
	run;
quit;

proc delete data=Work.reg_design;
run;


/*2 Logistic regression*/
ods noproctitle;
ods graphics / imagemap=on;

proc logistic data=WORK.BANKCHURNERS;
	class Gender Education_Level / param=glm;
	model Contacts_Count_12_mon / Dependent_count=Gender Education_Level / 
		link=probit technique=fisher;
run;


/*Corresspondence analysis */

ods noproctitle;
ods graphics / imagemap=on;

proc corresp data=WORK.BANKCHURNERS dimens=2 plots;
	tables Education_Level, Dependent_count;
run;


/*Binary Logistic Regression */
ods noproctitle;
ods graphics / imagemap=on;

proc pls data=WORK.BANKCHURNERS method=pls plots;
	class Education_Level;
	model Dependent_count=Customer_Age;
run;