%{
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>

int yylex();
void yyerror(const char *s){
      fprintf(stderr, "%s\n", s);
   };

   FILE *f;
   extern FILE *yyin; 

%}

%union
{
	char *str;
	int number;
};

%type <str>	program	varlist varret cmds cmd;
%token <str> ID;
%token <number> ENTRADA;
%token <number> SAIDA;
%token <number> FIM;
%token <number> INC;
%token <number> ZERA;
%token <number> ENQUANTO;
%token <number> FACA;
%token <number> SE;
%token <number> ENTAO;
%token <number> SENAO;
%token <number> VEZES;
%token <number> ABREPARENTESE;
%token <number> FECHAPARENTESE;
%token <number> IGUAL;

%start program
%%

program	: ENTRADA varlist SAIDA varret cmds FIM {
			fprintf(f, "#include <stdio.h>\n\n");
			fprintf(f, "int main(void) {\n");
			fprintf(f, "%s;\n", $2);
			fprintf(f, "int %s;\n\n", $4);
			fprintf(f, "%s", $5);
			fprintf(f,"printf(\"%%s\",%s);\n",$4);
			fprintf(f, "return 0;\n}");
			fclose(f);
			exit(0);
};
		
varlist	:	varlist ID {
			char *entrada = malloc(strlen($1) + strlen($2) + 5);
			sprintf(entrada, "%s, %s = 0", $1, $2);
			$$ = entrada;
}
| ID {
		char *var = malloc(strlen($1) + 5);
		sprintf(var, "int %s = 0", $1);
		$$ = var;
};

varret : ID {
		$$ = $1;
};	

cmds : cmds cmd {
		char * comandos = malloc(strlen($1) + strlen($2) + 1);
		sprintf(comandos, "%s%s\n", $1, $2);
		$$=comandos;
}
| cmd  {
	char *comando=malloc(strlen($1) + 5);
	sprintf(comando, "%s", $1);
	$$=comando;
};

cmd : ID IGUAL ID { 
		char *igualdade=malloc(strlen($1) + strlen($3) + 4);
		sprintf(igualdade, "%s=%s;\n",$1,$3);
		$$ = igualdade;
}
| INC ABREPARENTESE ID FECHAPARENTESE { 
	char *incre = malloc(strlen($3) + 4);
	sprintf(incre, "%s++;\n",$3);
	$$ = incre;
}
| ENQUANTO ID FACA cmds FIM { 
	char *loop = malloc(strlen($2) + strlen($4) + 20);
	sprintf(loop, "while (%s) {\n%s}\n", $2, $4);
	$$ = loop;
}
| ZERA ABREPARENTESE ID FECHAPARENTESE {
	char *zerar = malloc(strlen($3) + 4);
	sprintf(zerar, "%s=0;\n",$3);
	$$ = zerar;

}
| SE ID ENTAO cmds FIM {
	char *seEntao = malloc(strlen($2) + strlen($4) + 13);
	sprintf(seEntao, "if(%s){\n%s}\n", $2, $4);
	$$ = seEntao;

}
| SE ID ENTAO cmds SENAO cmds FIM {
	char *seEntaoSenao = malloc(strlen($2) + strlen($4) + strlen($6) + 24);
	sprintf(seEntaoSenao, "if(%s){\n%s}\nelse{\n%s}\n", $2, $4, $6);
	$$ = seEntaoSenao;
}
| FACA ID VEZES cmds FIM {
	char *repeticao = malloc(strlen($2) + strlen($4) + 50);
	sprintf(repeticao, "for(int i=0;i<%s;i++){\n%s}\n", $2, $4);
	$$ = repeticao;
}
;
	
%%

int main(int argc, char *argv[])
{
	FILE *provolone = fopen(argv[1], "r");
	f = fopen("codigoConvertido.c", "w+");

	if (f == NULL)
	{
		printf("Erro de abertura de arquivo\n");
		exit(1);
	}

    yyin = provolone;
    yyparse();
    return(0);
}
