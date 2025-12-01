# APA-analyse201712
Compute average age of GIR1 and GIR2 beneficiaries, including breakdown by sex

| Variable            | Type               | Description                                                                                                     |
| ------------------- | ------------------ | --------------------------------------------------------------------------------------------------------------- |
| `df`                | `data.frame`       | Loading raw RData file from DREES                                                         |
| `df_clean`          | `data.frame`       | Cleaned Dataset : without NA, filtering age >= 60, date before 01-01-2018, GIR 1 and 2 |
| `column_cheking_na` | `character vector` | Column NA list stored to check missing values                                                       |
| `df_meanage`        | `data.frame`       | Mean age per GIR (1 or 2), rounded to whole number                                                          |
| `df_meanage_sex`    | `data.frame`       | Mean age per GIR (1 or 2) and sex (Male/Female), rounded to whole number                                   |
| `tab_meanage_sex`   | `matrix`           | Matrix used to create a combined barplot, rows : "GIR" ; columns: "sexe"                                        |
| `bp_meanage_girsex` | `numeric vector`   | Initialize a barplot       |

