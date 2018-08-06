%{
// ---------------------------------------------
// ----- © Nader Trabelsi - December 2017 ------
// ---------------------------------------------
#define YYSTYPE char *
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
struct id{
char nom[40];
char type[40];
} liste_identif[40];
extern FILE *pf;
int nb_ident=0;
int ntpichE=0;
int ntpiE=0;
int ntpichL=0;
int ntpiL=0;
char *tabparam[] = {"%d","%i","%f","%s","%c",""},**t;
char ordre_ecr[70]="",ordre_ecr_ident[70]="",ordre_lec[70]="",ordre_lec_ident[70]="";;

%}
%token EGAL DIFF INF INFEGAL SUP SUPEGAL TANTQUE SI SINON ECRIRE LIRE ENT CHAINE IDENT POINT ACCFER ACCOUV DEFINE MOINS PLUS DIVI MULT PARFER PAROUV FONC_MAIN POINTVIRG VIRG AFFECT FAIRE POUR
%start FICHIER
%%

FICHIER: PROGRAMME
	;
PROGRAMME: DECL_CONST PROGRAMME2
	| DECL_VAR PROG
	| PROG
	;
PROGRAMME2: DECL_VAR
	| PROG
	;
DECL_CONST: DEFINE IDENT ENT DECL_CONST2
	;
DECL_CONST2: DECL_CONST
	| %empty
	;
DECL_VAR: ENT IDENT_D DECL_VAR2
	;
IDENT_D: IDENT {
strcpy(liste_identif[nb_ident].nom,$1);
strcpy(liste_identif[nb_ident++].type,"entier");
}
	;
DECL_VAR2: SUITE_VAR POINTVIRG DECL_VAR3
	| POINTVIRG DECL_VAR
	| POINTVIRG
	;
DECL_VAR3: DECL_VAR
	| %empty
	;
SUITE_VAR: VIRG IDENT_D SUITE_VAR2
	;
SUITE_VAR2: SUITE_VAR
	| %empty
	;
PROG: FONC_MAIN PAROUV PARFER BLOC
	;
BLOC: INSTRUCTION | ACCOUV BLOC2
	;
BLOC2: AUTRES_INST ACCFER
	;
AUTRES_INST: INSTRUCTION AUTRES_INST2
	;
AUTRES_INST2: AUTRES_INST
	| %empty
	;
INSTRUCTION: CONDITIONNELLE
	| ITERATION
	| AFFECTATION
	| LECTURE
	| ECRITURE
	| BOUCLE
	;
BOUCLE: FAIRE_TANTQUE
	| BOUCLE_POUR
	;
FAIRE_TANTQUE: FAIRE BLOC TANTQUE PAROUV EXP PARFER POINTVIRG
	;
BOUCLE_POUR: POUR PAROUV AFFECTATION EXP POINTVIRG AFFECTATION_SPV PARFER BLOC
	;
CONDITIONNELLE: SI PAROUV EXP PARFER BLOC SUITE_COND
	;
SUITE_COND: %empty
	| SINON BLOC
	;
ITERATION: TANTQUE PAROUV EXP PARFER BLOC
	;
AFFECTATION: IDENT AFFECT EXP POINTVIRG
	;
AFFECTATION_SPV: IDENT AFFECT EXP
	;
LECTURE: LIRE PAROUV IDENT PARFER POINTVIRG
	| LECTURE_AVEC_PARAM
	;
LECTURE_AVEC_PARAM: LIRE PAROUV CHAINE_L LISTE_IDENT_L PARFER POINTVIRG
	;
CHAINE_L: CHAINE {
// Réupération de la chaine à analyser
char sousCh[1000];
char ch[1000]="";
strcat(ch,$1);
int i=0,j;
while(i<strlen(ch)-2){
sousCh[i] = ch[1+i];
i++;
}
sousCh[i] ='\0';

// Calcul du nombre d'occurences des %lettre de c
  int compteur = 0;
  t=tabparam;
while(*t != ""){
  const char *tmp = sousCh;
 while(tmp = strstr(tmp, *t))
  {
   compteur++;
   tmp++;
  }
  t++;
 }
ntpichL=ntpichL+compteur;

// Memorisation de l'ordre des types des variables dans la chaine
char chtmp[3];
for(i=0;i<=strlen(sousCh)-2;i++){
chtmp[0]=sousCh[i];chtmp[1]=sousCh[i+1];chtmp[2]='\0';
if (strcmp(chtmp,*tabparam)==0) strcat(ordre_lec,"E");
else {
 t=tabparam;
 t++;
 while(*t != ""){
  if (strcmp(chtmp,*t)==0) {
  strcat(ordre_lec,"A"); 
  }
  t++;
 }
}
}

}
	;
LISTE_IDENT_L: VIRG '&' IDENT_L LISTE_IDENT_L { ntpiL=ntpiL+1;}
	| LISTE_IDENT_L
	| %empty
	;
IDENT_L: IDENT {
int j,ex=0;
// Memorisation de l'ordre des types des variables hors chaine
for (j=0;j<=nb_ident;j++){
if (strcmp(liste_identif[j].nom,$1)==0) ex=1;
//if (strcmp(liste_identif[j].type,"entier")==0) ==> Possiblité de considérer d'autres types
}
if (ex==0) strcat(ordre_lec_ident,"A");
else strcat(ordre_lec_ident,"E");
}
	;
ECRITURE: ECRIRE PAROUV ECRITURE2
	| ECRITURE_AVEC_PARAM
	;
ECRITURE_AVEC_PARAM: ECRIRE PAROUV CHAINE_E LISTE_IDENT_E PARFER POINTVIRG
	;
CHAINE_E: CHAINE {
// Réupération de la chaine à analyser
char sousCh[1000];
char ch[1000]="";
strcat(ch,$1);
int i=0,j;
while(i<strlen(ch)-2){
sousCh[i] = ch[1+i];
i++;
}
sousCh[i] ='\0';

// Calcul du nombre d'occurences des "%lettre" du langage c
  int compteur = 0;
  t=tabparam;
while(*t != ""){
  const char *tmp = sousCh;
 while(tmp = strstr(tmp, *t))
  {
   compteur++;
   tmp++;
  }
  t++;
 }
ntpichE=ntpichE+compteur;

// Memorisation de l'ordre des types des variables dans la chaine
char chtmp[3];
for(i=0;i<=strlen(sousCh)-2;i++){
chtmp[0]=sousCh[i];chtmp[1]=sousCh[i+1];chtmp[2]='\0';
if (strcmp(chtmp,*tabparam)==0) strcat(ordre_ecr,"E");
else {
 t=tabparam;
 t++;
 while(*t != ""){
  if (strcmp(chtmp,*t)==0) {
  strcat(ordre_ecr,"A"); 
  }
  t++;
 }
}
}

}
	;
LISTE_IDENT_E: VIRG IDENT_E LISTE_IDENT_E {ntpiE=ntpiE+1;}
	| LISTE_IDENT_E
	| %empty
	;
IDENT_E: IDENT {
int j,ex=0;
// Memorisation de l'ordre des types des variables hors chaine
for (j=0;j<=nb_ident;j++){
if (strcmp(liste_identif[j].nom,$1)==0) ex=1;
//if (strcmp(liste_identif[j].type,"entier")==0) ==> Possiblité de considérer d'autres types
}
if (ex==0) strcat(ordre_ecr_ident,"A");
else strcat(ordre_ecr_ident,"E");
}
	;
ECRITURE2: PARFER POINTVIRG
	| EXP_OU_CH ECRITURE3
	;
ECRITURE3: AUTRES_ECRI PARFER POINTVIRG
	| PARFER POINTVIRG
	;
AUTRES_ECRI: VIRG EXP_OU_CH AUTRES_ECRI2
	;
AUTRES_ECRI2: AUTRES_ECRI
	| %empty
	;
EXP_OU_CH: EXP
	| CHAINE
	;
EXP: TERME EXP2
	;
EXP2: OP_BIN EXP
	| OP_REL EXP
	| %empty
	;
TERME: ENT
	| IDENT
	| PAROUV EXP PARFER
	| MOINS TERME
	;
OP_BIN: PLUS
	| MOINS
	| MULT
	| DIVI
	;
OP_REL: EGAL
	| INF
	| INFEGAL
	| DIFF
	| SUPEGAL
	| SUP
	;
%%
#include"lex.yy.c"

int main(int argc, char *argv[])
{
int j=0,lec,ecr;
	yyin = fopen(argv[1], "r");
	
   if(!yyparse()){
   ecr=strcmp(ordre_ecr,ordre_ecr_ident);
   lec=strcmp(ordre_lec,ordre_lec_ident);
        if(ntpiE==ntpichE && ntpiL==ntpichL && !ecr && !lec){
        printf("Analyse syntaxique réussi!\n");
        }else {
         if(ntpiE!=ntpichE || ecr){
         printf("Erreur: Veuillez vérifier les paramètres de printf\n");
         }
         if(ntpiL!=ntpichL || lec){
         printf("Erreur: Veuillez vérifier les paramètres de scanf\n",ntpiL,ntpichL);
         }
        }
        }
	else
	   printf("Analyse syntaxique échoué!\n");

	fclose(yyin);
    return 0;
}
         
yyerror(char *s) {
	printf("Ligne (%d) : %s %s\n", yylineno, s, yytext );
}         

