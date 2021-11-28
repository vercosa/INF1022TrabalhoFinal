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
\n return(NEWLINE);
[a-zA-Z]	{yylval.str = strdup(yytext); return (ID);}
.	{}
%%
int yywrap() {}
