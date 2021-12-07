%{
	#include <stdio.h>
	#include <string.h>
	#include "gramatica.tab.h"
%}
%%

ENTRADA return(ENTRADA);
SAIDA return(SAIDA);
FIM return(FIM);
INC return(INC);
ZERA return(ZERA);
ENQUANTO return(ENQUANTO);
FACA return(FACA);
SE return(SE);
ENTAO return(ENTAO);
SENAO return(SENAO);
VEZES return(VEZES);
"(" return(ABREPARENTESE);
")" return(FECHAPARENTESE);
"="	return(IGUAL);
[a-zA-Z]	{yylval.str = strdup(yytext); return (ID);}
[ \t\n]+ { }
%%

int yywrap() {}
