# File guide

What every file in this repository is, and how they fit together.

## Top level

| File | What it is |
|---|---|
| `README.md` | Project summary, key results, methods, limitations and how to run. |
| `.gitignore` | Stops SPSS backup files and operating-system files (such as `.DS_Store`) from being committed. |

## `syntax/`

| File | What it is |
|---|---|
| `analysis.sps` | The full SPSS analysis as one runnable syntax file. Open `data/Data_Analysis_Project.sav` in SPSS, then open this file and click **Run → All**. |

The file has five sections:

1. **Frequencies of the original variables.** These identify the missing, "Don't know" and "Prefer not to answer" codes.
2. **Derived variables.** These are the recodes for vote, age at the referendum, sex, region, religion and education, plus the 0/1 dummy variables used for the VIF check.
3. **Chi-square tests.** One crosstab of each factor by vote, with row percentages and a clustered bar chart.
4. **Multicollinearity check.** A linear regression run only to obtain tolerance and VIF for the dummy predictors.
5. **Binary logistic regression.** All five factors are entered together, with the first category of each as the reference group.

The analysis itself was run through the SPSS menus. Sections 3–5 are the exact commands SPSS recorded in the output file. Sections 1–2 write out the recodes as syntax, and they reproduce the derived variables exactly.

## `output/`

| File | What it is |
|---|---|
| `Data_Analysis_Project.spv` | The original SPSS output file. It contains every frequency table, crosstab, chi-square test, bar chart, collinearity table and logistic regression table from the project. Open it in SPSS or the free [IBM SPSS Statistics Viewer](https://www.ibm.com/support/pages/downloading-ibm-spss-statistics-viewer). |

## `results/`

Every result table, as CSV, so they can be read without SPSS. The values are taken from the SPSS output in `output/Data_Analysis_Project.spv`.

| File | What it contains |
|---|---|
| `01_sample_descriptives.csv` | Counts and valid percentages for every derived variable, plus the number excluded from each. |
| `02_vote_by_group_crosstabs.csv` | Remain and Leave counts and row percentages for every demographic group. |
| `03_chi_square_tests.csv` | Each factor's Pearson chi-square, df and p-value, plus the likelihood-ratio and linear-by-linear statistics SPSS reports. For sex (a 2×2 table), it also gives the continuity-corrected value. |
| `04_multicollinearity_vif.csv` | Tolerance and VIF for each dummy predictor. |
| `05_logistic_regression_odds_ratios.csv` | B, SE, Wald, p-value, odds ratio and 95% confidence interval for every term in the logistic regression. |
| `06_logistic_regression_model_fit.csv` | Sample size, −2 log likelihood, omnibus chi-square, Cox & Snell and Nagelkerke R², and classification accuracy. |

## `data/`

| File | What it is |
|---|---|
| `Data_Analysis_Project.sav` | The SPSS dataset used for the whole analysis: British Social Attitudes Survey 2023, 5,578 respondents × 439 variables. Open it with **File → Open → Data**. |

**What's in the dataset**

- **405 original survey variables.** This is the version of the survey provided for the IJC466 module.
- **34 derived variables that I created**, which are the last 34 columns in the file:
  - the six analysis variables (see the table below)
  - the 0/1 dummy variables used for the VIF check (`Age_EURef1_1` … `Religion1_5`)
  - two variables I created but didn't use in the final analysis (`LeftorRight` with its dummies, and `MaritalStatus`)
- **The survey weight `BSA23_final_wt`.** The analysis was run unweighted (see *Limitations* in the main README).

**Variables used**

| Original variable | Description | Derived variable |
|---|---|---|
| `EURefVote` | Did you vote to remain a member of the EU or to leave the EU? | `EUVote` (0 = Remain, 1 = Leave) |
| `RespAge_Archive` | Age last birthday (top-coded: 22 = 18–22, 80 = 80 or more) | `Age_EURef` (age at the 2016 referendum, 5 bands) |
| `DVsex23` | Sex | `SexofResp` |
| `GOR` | Government Office Region (11 regions of Great Britain) | `Location` (6 groups) |
| `Religsum` | Religion, summary (6 categories) | `Religion` (5 groups) |
| `HEdQual2` | Highest educational qualification | `Education` (5 levels) |

The exact recoding rules are in `syntax/analysis.sps`, section 2.

**Citation:** National Centre for Social Research. (2024). *British Social Attitudes Survey, 2023* [Data collection]. UK Data Service. SN: 9363. https://doi.org/10.5255/UKDA-SN-9363-1

## `docs/`

| File | What it is |
|---|---|
| `report.pdf` | The full report. Sections: introduction and literature review, methods, results (descriptive statistics in Tables 4–9, chi-square crosstabs in Tables 10–14 with Figures 1–5, logistic regression in Table 15), discussion, conclusion and references. The appendix contains the complete SPSS output. |
| `FILE_GUIDE.md` | This file. |
| `BSA_2023_user_guide.pdf` | NatCen's official user guide to the survey: sample design, fieldwork, weighting (`BSA23_final_wt`) and derived variables. |
| `BSA_2023_cheat_sheet.docx` | The module's quick guide to the dataset: variable types (`_Archive` and `DV` variables), key demographic variables and example research questions. |

## How the files connect

```
data/Data_Analysis_Project.sav
        │
        └──► syntax/analysis.sps ──► output/Data_Analysis_Project.spv ──► docs/report.pdf
                                              │
                                              └──► results/*.csv  (key tables, as CSV)
```
