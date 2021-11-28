%{
      #include <stdlib.h>
      #include <stdio.h>
      #include <string.h>

int yylex();
void yyerror(const char *s){
      fprintf(stderr, "%s\n", s);
   };
//Arquivo de saida.c
   FILE *f;
    extern FILE *yyin; 

%}

%union
{
	char *str;
	int number;
};

%type <str>	program	varlist;
%token <str> ID;
%token <number> ENTRADA;
%token <number> SAIDA;
%token <number> END;
%token <number> FIM;
%token <number> NEWLINE;

%start program
%%

program	: ENTRADA varlist SAIDA varlist END NEWLINE {
			fprintf(f, "#include <stdio.h>\n\n");
			fprintf(f, "int main(void) {\n");
			fprintf(f, "%s\n%s\n", $2, $4);
			fprintf(f, "return 0;\n}");
			fclose(f);
			exit(0);
};
		
varlist	:	varlist ID {
			char *entrada = malloc(strlen($1) + strlen($2) + 5);
			sprintf(entrada, "int %s = 0, %s = 0;", $1, $2);
			$$ = entrada;
};
| ID {
		char *var = malloc(strlen($1) + 5);
		sprintf(var, "%s", $1);
		$$ = var;
};
%%

int main(int argc, char *argv[])
{
	FILE *provolone = fopen(argv[1], "r");
	f = fopen("codigo.c", "w+");

	if (f == NULL)
	{
		printf("Erro de abertura de arquivo\n");
		exit(1);
	}
    yyin = provolone;
    yyparse();
    return(0);
}
