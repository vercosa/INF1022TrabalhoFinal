%{
	#include <stdio.h>
	#include <string.h>
	#include "gramatica.tab.h"
%}
%%

ENTRADA return(ENTRADA);
SAIDA return(SAIDA);
END return(END);
FIM return(FIM);
INC return(INC);
ENQUANTO return(ENQUANTO);
FACA return(FACA);
"(" return(ABREPARENTESE);
")" return(FECHAPARENTESE);
\n return(NEWLINE);
[a-zA-Z]	{yylval.str = strdup(yytext); return (ID);}
"="	return(IGUAL);
.	{}
%%
int yywrap() {}
