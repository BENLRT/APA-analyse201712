####################

# Name : APA-analyse201712
# Author : Bénédicte LORIOT
# Date : 2025-12-01
# Dataset source : https://data.drees.solidarites-sante.gouv.fr/explore/dataset/beneficiaires-apa-a-domicile-base-floutee-v1/information/
# Objective: Compute average age of GIR1 and GIR2 beneficiaries, including breakdown by sex

################


# EXPLORING

## Loading dataset
load(url("https://data.drees.solidarites-sante.gouv.fr/api/datasets/1.0/beneficiaires-apa-a-domicile-base-floutee-v1/attachments/ben_apad_floutee_v1_rdata/"))
df <- echantillon_diffusion
## Exploring columns and lines
str(df)

## Count number of na values
sum(is.na(df))
colSums(is.na(df))

## Sum number of duplicated value 
### (they won't be cleaned as a line does not have any unique id 
### or if there is a duplicated value we cannot say if it's normal or not)
sum(duplicated(df)) 


# CLEANING 
df_clean <- df

## Renaming columns 
colnames(df_clean) <- c("age","sexe","departement","situation_couple","proche_aidant",
                  "protection_juridique","gir","date_eval_gir","date_ouverture_droit",
                  "coherence","orientation","toilette","habillage","alimentation","elimination","transferts","deplacement_interieur","deplacement_exterieur","communication_distance",
                  "mensuel_APA","mensuel_conseil_departemental","mensuel_participation_ben", "total_apa","apa_aide_humaine","mensuel_aide_humaine","nb_heure_aide_humaine","ressources_apa",
                  "autre_aide","aide_ponctuelle","aide_répit_hospi","hebergement_temp","accueil_jour","aide_transport","aide_humaine",
                  "poids_ponderation")

## Deleting NA on columns needed 
column_cheking_na <- c("age", "sexe","gir","date_ouverture_droit")
df_clean <- df_clean[complete.cases(df_clean[,column_cheking_na]), ]

## Renaming values of sexe column from 1-2 to "homme-femme" 
## to make it readable for analysis
df_clean$sexe <- ifelse(df_clean$sexe == "1","Homme","Femme")

## Keeping only more or equal to age of 60yo (minimum age for APA)
df_clean <- df_clean[df_clean$age >= 60,]

## Filtering columns before 01-01-2018
df_clean <- df_clean[df_clean$date_ouverture_droit < as.Date("2018-01-01"), ]

## Filtering columns on GIR 1 and GIR 2
df_clean <- df_clean[df_clean$gir < 3,]


# ANALYZING

## Calculating mean age GIR 1 and 2 
df_meanage <- aggregate(age ~ gir, data = df_clean, FUN = mean)
df_meanage$age <- round(df_meanage$age, 0)
###  Renaming columns
colnames(df_meanage) <- c("gir","age_moyen")

## Calculating mean age GIR 1 and 2 by sex 
df_meanage_sex <- aggregate(age ~ gir + sexe , data = df_clean, FUN = function(x) round(mean(x),0))
df_meanage_sex$age <- round(df_meanage_sex$age, 0)
### Renaming columns
colnames(df_meanage_sex) <- c("gir","sexe","age_moyen")

## Creating matrix for barplot 
tab_meanage_sex <- tapply(df_meanage_sex$age_moyen, list(df_meanage_sex$gir, df_meanage_sex$sexe), mean)
###  Renaming rows
rownames(tab_meanage_sex) <- c("GIR1", "GIR2")
###  Renaming columns
colnames(tab_meanage_sex) <- c("FEMME", "HOMME")

# Print Results
## Mean age for GIR1 and GIR2 Dataframe
cat("\n Âge moyen par GIR \n")
print(df_meanage)

## Mean age for GIR1 and GIR2 by sex
cat("\n Âge moyen par GIR et Sexe \n")
print(df_meanage_sex)

## Create barplot 
bp_meanage_girsex <-  barplot(tab_meanage_sex,
                              beside = TRUE,            
                              legend = rownames(tab_meanage_sex),     
                              main = "Âge moyen par sexe et GIR",
                              xlab = "Sexe",
                              ylab = "Âge moyen",
)

# EXPORTING DATA

## Exporting barplot in .png
dev.copy(png, "dec-2017_meanage-per-gir-and-sex.png", width=800, height=600)
dev.off()

## Exporting dataframes to csv
write.csv(df_meanage,"dec-2017_meanage-per-gir.csv", row.names = FALSE)
write.csv(df_meanage_sex,"dec-2017_meanage-per-gir-and-sex.csv", row.names = FALSE)
