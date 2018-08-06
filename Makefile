# ---------------------------------------------
# ----- © Nader Trabelsi - December 2017 ------
# ---------------------------------------------

all: compilateurMiniC
	
compilateurMiniC.tab.c: compilateurMiniC.y lex.yy.c
	bison compilateurMiniC.y

lex.yy.c: compilateurMiniC.l
	flex compilateurMiniC.l
	
compilateurMiniC: compilateurMiniC.tab.c
	gcc compilateurMiniC.tab.c -ll -ly -w -o compilateurMiniC
	
clean:
	rm compilateurMiniC lex.yy.c compilateurMiniC.tab.c
