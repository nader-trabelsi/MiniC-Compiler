%{
// ---------------------------------------------
// ----- © Nader Trabelsi - December 2017 ------
// ---------------------------------------------
#include <stdio.h>
%}
alpha [a-zA-Z]
chiffre [0-9]

%%
[ \t]	;
[ \n]   { yylineno = yylineno + 1;}
"scanf" return LIRE;
"do" return FAIRE;
"for" return POUR;
"+" return PLUS;
"-" return MOINS;
"*" return MULT;
"/" return DIVI;
"<=" return INFEGAL;
">=" return SUPEGAL;
"==" return EGAL;
"!=" return DIFF;
"<" return INF;
">" return SUP;
"." return POINT;
"=" return AFFECT;
"," return VIRG;
";" return POINTVIRG;
"(" return PAROUV;
")" return PARFER;
"{" return ACCOUV;
"}" return ACCFER;
"#define" return DEFINE;
"main" return FONC_MAIN;
"while"	return TANTQUE;
"if" return SI;
"else" return SINON;
"printf" return ECRIRE;
{chiffre}+       return ENT;
\"([^\\\"])*\" {yylval=yytext;return CHAINE;} 
{alpha}({alpha}|{chiffre})* {yylval=yytext;return IDENT;}
\/\/.* ;
\/\*(.*\n)*.*\*\/ ;
. return yytext[0];
%%
