# INF1022TrabalhoFinal

sudo flex lexico.l
sudo bison -d gramatica.y
gcc -o provolone lex.yy.c gramatica.tab.c
./provolone entrada.provolone