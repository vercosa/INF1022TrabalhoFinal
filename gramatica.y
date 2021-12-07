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

	int linha = 1;
	char * varEntrada[50];
	char * varSaida;
	int qtdVarEntrada = 0;

	int buscaVariavelEntrada (char * x) {
		for (int i = 0; i < qtdVarEntrada; i++)
		{
			if (strcmp(varEntrada[i], x)==0)
				return 1;
		}
		return 0;
	}

	int buscaVariavel (char * x)
	{
		if (buscaVariavelEntrada (x)==1 || strcmp(varSaida, x)==0)
			return 1;
		else
			return 0;
	}

	void insereVariavelEntrada (char * x)
	{
		if (qtdVarEntrada > 0)
		{
			if (buscaVariavelEntrada(x)==1)
			{
				printf("Erro na linha %d: Variável %s de entrada ja foi declarada\n ", linha, x);
				exit(0);
			}
			else
			{
				varEntrada[qtdVarEntrada] = x;
				qtdVarEntrada++;
			}
		}
		else
		{
			varEntrada[qtdVarEntrada] = x;
			qtdVarEntrada++;
		}
	}

	void insereVariavelSaida (char * x)
	{
		if (buscaVariavelEntrada(x)==1)
		{
			printf("Erro na linha %d: Variável %s de saida ja foi declarada como variavel de entrada\n ", linha, x);
			exit(0);
		}
		else
			varSaida = x;
	}
	
	
	void checarVariavelExiste (char * x)
	{
		if (buscaVariavel(x)==0)
		{
			printf("Erro na linha %d: Variável %s nao foi declarada\n", linha, x);
			exit(0);
		}
	}
	

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
			fprintf(f, "\t%s;\n", $2);
			fprintf(f, "\tint %s;\n\n", $4);
			fprintf(f, "%s", $5);
			fprintf(f,"\tprintf(\"%%s\",%s);\n",$4);
			fprintf(f, "\treturn 0;\n}");
			fclose(f);
			exit(0);
};
		
varlist	:	varlist ID {
			char *entrada = malloc(strlen($1) + strlen($2) + 5);
			sprintf(entrada, "%s, %s = 0", $1, $2);
			insereVariavelEntrada ($2);
			$$ = entrada;
}
| ID {
		char *var = malloc(strlen($1) + 5);
		sprintf(var, "int %s = 0", $1);
		insereVariavelEntrada ($1);
		$$ = var;
};

varret : ID {
		linha++;
		insereVariavelSaida ($1);
		$$ = $1;
		
};	

cmds : cmds cmd {
		linha++;
		char * comandos = malloc(strlen($1) + strlen($2) + 1);
		sprintf(comandos, "%s%s\n", $1, $2);
		$$=comandos;
}
| cmd  {
	linha++;
	char *comando=malloc(strlen($1) + 5);
	sprintf(comando, "%s", $1);
	$$=comando;
};

cmd : ID IGUAL ID { 
		checarVariavelExiste  ($1);
		checarVariavelExiste  ($3);
		char *igualdade=malloc(strlen($1) + strlen($3) + 4);
		sprintf(igualdade, "\t%s=%s;\n",$1,$3);
		$$ = igualdade;
}
| INC ABREPARENTESE ID FECHAPARENTESE { 
	checarVariavelExiste  ($3);
	char *incre = malloc(strlen($3) + 4);
	sprintf(incre, "\t%s++;\n",$3);
	$$ = incre;
}
| ENQUANTO ID FACA cmds FIM { 
	checarVariavelExiste  ($2);
	char *loop = malloc(strlen($2) + strlen($4) + 20);
	sprintf(loop, "\twhile (%s) {\n\t%s\t}\n", $2, $4);
	linha++;
	$$ = loop;
}
| ZERA ABREPARENTESE ID FECHAPARENTESE {
	checarVariavelExiste  ($3);
	char *zerar = malloc(strlen($3) + 4);
	sprintf(zerar, "\t%s=0;\n",$3);
	$$ = zerar;

}
| SE ID ENTAO cmds FIM {
	checarVariavelExiste  ($2);
	char *seEntao = malloc(strlen($2) + strlen($4) + 13);
	sprintf(seEntao, "\tif(%s){\n\t%s\t}\n", $2, $4);
	linha++;
	$$ = seEntao;

}
| SE ID ENTAO cmds SENAO cmds FIM {
	checarVariavelExiste  ($2);
	char *seEntaoSenao = malloc(strlen($2) + strlen($4) + strlen($6) + 24);
	sprintf(seEntaoSenao, "\tif(%s){\n\t%s\t}\n\telse {\n\t%s\t}\n", $2, $4, $6);
	linha++;
	linha++;
	$$ = seEntaoSenao;
}
| FACA ID VEZES cmds FIM {
	checarVariavelExiste  ($2);
	char *repeticao = malloc(strlen($2) + strlen($4) + 50);
	sprintf(repeticao, "\tfor(int i=0;i<%s;i++){\n\t%s\t}\n", $2, $4);
	linha++;
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
