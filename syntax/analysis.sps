* Encoding: UTF-8.
* =============================================================================
* Demographic factors and the 2016 UK EU Referendum vote
* Evidence from the British Social Attitudes Survey 2023
*
* IJC466 Data Analysis - MSc Data Science, University of Sheffield
* Software: IBM SPSS Statistics 31
*
* HOW TO RUN
*   1. Open data/Data_Analysis_Project.sav in SPSS (File > Open > Data).
*   2. Open this file (File > Open > Syntax), then Run > All.
*   The dataset already contains the derived variables. Running section 2
*   rebuilds them from the original survey variables, with identical values.
*
* ABOUT THIS FILE
*   The analysis was carried out through the SPSS menus. Sections 3-5 are the
*   exact commands SPSS logged in the output file (output/Data_Analysis_Project.spv).
*   Sections 1-2 (the recodes) are written out here as syntax. Checked against the
*   derived variables in data/Data_Analysis_Project.sav, they reproduce every
*   value exactly.
* =============================================================================.


* -----------------------------------------------------------------------------
* 1. FREQUENCIES OF THE ORIGINAL BSA VARIABLES
*    Used to find missing / "Don't know" / "Prefer not to answer" codes.
* -----------------------------------------------------------------------------.
FREQUENCIES VARIABLES=EURefVote RespAge_Archive DVsex23 GOR Religsum HEdQual2
  /STATISTICS=MINIMUM MAXIMUM
  /ORDER=ANALYSIS.


* -----------------------------------------------------------------------------
* 2. DERIVED VARIABLES
*    Missing data, "Don't know" and "Prefer not to answer" are set to
*    system-missing and excluded from every analysis.
* -----------------------------------------------------------------------------.

* 2a. Dependent variable: EU Referendum vote (0 = Remain, 1 = Leave).
*     Excludes: not asked (n = 1,404), Don't know (n = 6), Prefer not to answer (n = 57).
RECODE EURefVote (1=0) (2=1) (ELSE=SYSMIS) INTO EUVote.
VARIABLE LABELS EUVote "Respondent's Vote in the EU Referendum".
VALUE LABELS EUVote 0 'Remain a Member of the EU' 1 'Leave the EU'.

* 2b. Age at the time of the 2016 referendum = age in 2023 minus 7 years.
*     RespAge_Archive is top-coded (22 = "18-22", 80 = "80 or more") and
*     999 = "Prefer not to answer" (n = 31).
*     Respondents under 18 in 2016 were not eligible to vote and are excluded (n = 314).
IF (RespAge_Archive GE 18 AND RespAge_Archive LE 80) Age_2016 = RespAge_Archive - 7.
RECODE Age_2016 (18 THRU 24=1) (25 THRU 34=2) (35 THRU 50=3) (51 THRU 64=4)
  (65 THRU HIGHEST=5) (ELSE=SYSMIS) INTO Age_EURef.
VARIABLE LABELS Age_EURef "Respondent's Age at the Time of the EU Referendum".
VALUE LABELS Age_EURef 1 '18 - 24' 2 '25 - 34' 3 '35 - 50' 4 '51 - 64' 5 '65+'.

* 2c. Sex. Excludes Prefer not to answer (n = 4).
RECODE DVsex23 (1=1) (2=2) (ELSE=SYSMIS) INTO SexofResp.
VARIABLE LABELS SexofResp "Sex of Respondent".
VALUE LABELS SexofResp 1 'Female' 2 'Male'.

* 2d. Region: 11 Government Office Regions collapsed into 6 groups.
RECODE GOR (7=1) (8,9=2) (4,5,6=3) (1,2,3=4) (10=5) (11=6) (ELSE=SYSMIS) INTO Location.
VARIABLE LABELS Location "Region that Respondent Lives In".
VALUE LABELS Location
  1 'London'
  2 'South East England and South West England'
  3 'East Midlands, West Midlands, and the East of England'
  4 'North East England, North West England, and Yorkshire and The Humber'
  5 'Wales'
  6 'Scotland'.

* 2e. Religion, reordered so that "No religion" is category 1 (the reference group).
*     Excludes Don't know / Refused / Not answered (n = 79).
RECODE Religsum (5=1) (4=2) (3=3) (2=4) (1=5) (ELSE=SYSMIS) INTO Religion.
VARIABLE LABELS Religion "Religion of the Respondent".
VALUE LABELS Religion 1 'No Religion' 2 'Non-Christian' 3 'Other Christian'
  4 'Roman Catholic' 5 'Church of England/Anglican'.

* 2f. Highest qualification. Excludes Don't know (n = 90) and Prefer not to answer (n = 48).
RECODE HEdQual2 (1=1) (2=2) (3=3) (4=4) (6=5) (ELSE=SYSMIS) INTO Education.
VARIABLE LABELS Education "Respondent's Highest Education Attained".
VALUE LABELS Education
  1 'Degree or equivalent, and above'
  2 'Other Higher Education, including Diplomas in Higher Education, HNC and HND'
  3 'A-levels/SCE Highers including vocational level 3 or equivalent, and above'
  4 'Qualifications below A-levels, such as GCSE/O Level/Standard Grade, vocational level 2 or equivalent'
  5 'No qualifications'.

* 2g. 0/1 dummy variables, used only for the multicollinearity (VIF) check in section 5.
*     A comparison such as (Age_EURef = 2) returns 1 or 0, and stays missing when Age_EURef is missing.
COMPUTE Age_EURef1_1 = (Age_EURef = 1).
COMPUTE Age_EURef1_2 = (Age_EURef = 2).
COMPUTE Age_EURef1_3 = (Age_EURef = 3).
COMPUTE Age_EURef1_4 = (Age_EURef = 4).
COMPUTE Age_EURef1_5 = (Age_EURef = 5).
COMPUTE SexofResp1_1 = (SexofResp = 1).
COMPUTE SexofResp1_2 = (SexofResp = 2).
COMPUTE Location1_1  = (Location = 1).
COMPUTE Location1_2  = (Location = 2).
COMPUTE Location1_3  = (Location = 3).
COMPUTE Location1_4  = (Location = 4).
COMPUTE Location1_5  = (Location = 5).
COMPUTE Location1_6  = (Location = 6).
COMPUTE Education1_1 = (Education = 1).
COMPUTE Education1_2 = (Education = 2).
COMPUTE Education1_3 = (Education = 3).
COMPUTE Education1_4 = (Education = 4).
COMPUTE Education1_5 = (Education = 5).
COMPUTE Religion1_1  = (Religion = 1).
COMPUTE Religion1_2  = (Religion = 2).
COMPUTE Religion1_3  = (Religion = 3).
COMPUTE Religion1_4  = (Religion = 4).
COMPUTE Religion1_5  = (Religion = 5).
EXECUTE.

* Check the derived variables.
FREQUENCIES VARIABLES=Age_EURef Education EUVote Location Religion SexofResp
  /STATISTICS=MINIMUM MAXIMUM
  /ORDER=ANALYSIS.


* -----------------------------------------------------------------------------
* 3. CHI-SQUARE TESTS OF INDEPENDENCE (each demographic factor by vote)
*    Row percentages = % of each group voting Remain / Leave.
* -----------------------------------------------------------------------------.
CROSSTABS
  /TABLES=Age_EURef BY EUVote
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW
  /COUNT ROUND CELL
  /BARCHART.

CROSSTABS
  /TABLES=SexofResp BY EUVote
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW
  /COUNT ROUND CELL
  /BARCHART.

CROSSTABS
  /TABLES=Location BY EUVote
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW
  /COUNT ROUND CELL
  /BARCHART.

CROSSTABS
  /TABLES=Religion BY EUVote
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW
  /COUNT ROUND CELL
  /BARCHART.

CROSSTABS
  /TABLES=Education BY EUVote
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ
  /CELLS=COUNT ROW
  /COUNT ROUND CELL
  /BARCHART.


* -----------------------------------------------------------------------------
* 4. MULTICOLLINEARITY CHECK (VIF)
*    SPSS only reports VIF in linear regression, so the dummy predictors are
*    entered into a linear model. The dependent variable is a placeholder:
*    only the Tolerance / VIF columns are read. Reference groups are left out.
* -----------------------------------------------------------------------------.
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10) TOLERANCE(.0001)
  /NOORIGIN
  /DEPENDENT RespAge_Archive
  /METHOD=ENTER Age_EURef1_2 Age_EURef1_3 Age_EURef1_4 Age_EURef1_5
    Education1_2 Education1_3 Education1_4 Education1_5
    Location1_2 Location1_3 Location1_4 Location1_5 Location1_6
    SexofResp1_2 Religion1_2 Religion1_3 Religion1_4 Religion1_5.


* -----------------------------------------------------------------------------
* 5. BINARY LOGISTIC REGRESSION
*    Outcome: EUVote (1 = Leave). All five factors entered together.
*    Indicator(1) makes the first category of each factor the reference group:
*    18-24, Degree or above, London, No religion, Female.
* -----------------------------------------------------------------------------.
LOGISTIC REGRESSION VARIABLES EUVote
  /METHOD=ENTER Age_EURef Education Location Religion SexofResp
  /CONTRAST (Age_EURef)=Indicator(1)
  /CONTRAST (Education)=Indicator(1)
  /CONTRAST (Location)=Indicator(1)
  /CONTRAST (Religion)=Indicator(1)
  /CONTRAST (SexofResp)=Indicator(1)
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).
