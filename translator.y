//  Arquivo Bison para o tradutor de Latex para Markdown
//  By: Rafael de Melo

%{
  #include <stdio.h> 
  #include <stdlib.h>
  #include <string.h>
  char string[100];
  int i;
  extern int yylineno;
  int countCapter = 0, countSec = 0, countSubSec = 0, countList = 0, countSpace = -1;
  FILE *f;
%}

//declaracao dos tokens
%token <sval> CLASSE PACOTE TITULO CONTEUDO AUTOR 
%token '{' '}' chapter begin end section subsection paragraph bf underline it document enumerate itemize item 
%union {
  char *sval;
}
%start documentoLatex
%%

documentoLatex: configuracao identificacao principal ;

configuracao: CLASSE PACOTE 
    | CLASSE 
    ;

identificacao: TITULO AUTOR {for(i = 7; $1[i] != '}'; i++){ string[i-7] = $1[i];} fprintf(f,"# %s\n", string); for(i = 8; $2[i] != '}'; i++){ string[i-8] = $2[i];} fprintf(f,"## %s\n", string);}
    | TITULO {for(i = 6; $1[i] != '}'; i++){ string[i-6] = $1[i];} fprintf(f,"# %s\n", string); }
    ;

principal: inicio corpoLista fim { };

inicio: begin '{' document '}' { };

fim: end '{' document '}' { };

corpoLista: capitulo secao subsecao corpoLista 
    | corpo 
    ;

capitulo: chapter '{' CONTEUDO '}' {countCapter++; fprintf(f, "####%d. %s\n\n",countCapter, $3); free($3);} corpo capitulo 
    | chapter '{' CONTEUDO '}' {countCapter++; fprintf(f, "####%d. %s\n\n",countCapter, $3); free($3);}
    ;

secao: section '{' CONTEUDO '}' {countSec++;fprintf(f, "#####%d.%d. %s\n\n", countCapter, countSec, $3);} corpo secao 
    | corpo
    ;

subsecao: subsection '{' CONTEUDO '}' {countSubSec++; fprintf(f, "######%d.%d.%d. %s\n\n",countCapter, countSec, countSubSec, $3);} corpo subsecao 
    | corpo
    ;

corpo: texto 
    | texto corpo 
    | textoEstilo corpo
    | listas corpo
    ;

texto: paragraph '{' CONTEUDO '}' {fprintf(f, "%s\n\n", $3);} 
       | /*Nothing*/
       ;

textoEstilo: bf '{' CONTEUDO '}' {fprintf(f, "**%s**", $3);}
    | underline '{' CONTEUDO '}' {fprintf(f, "%s", $3);}
    | it '{' CONTEUDO '}' {fprintf(f, "*%s*", $3);}
    ;

listas: listaNumerada
    | listaItens
    ;

listaNumerada: begin '{' enumerate '}'{countSpace++;} itensLNumerada end '{' enumerate '}' {countSpace--; fprintf(f, "\n");} ;

itensLNumerada: item '{' CONTEUDO '}' {for(i = 0; i < countSpace; i++){fprintf(f,"\t");} fprintf(f, "1.  %s\n", $3);}
    | item '{' CONTEUDO '}'  {for(i = 0; i < countSpace; i++){fprintf(f,"\t");} fprintf(f, "1.  %s\n", $3);} itensLNumerada
    | listas
    ;

listaItens: begin '{' itemize '}' {countSpace++;} itensLItens end '{' itemize '}' {countSpace--; fprintf(f, "\n");} ;

itensLItens: item '{' CONTEUDO '}' {for(i = 0; i < countSpace; i++){fprintf(f,"\t");} fprintf(f, "*  %s\n", $3);}
    | item '{' CONTEUDO '}' {for(i = 0; i < countSpace; i++){fprintf(f,"\t");} fprintf(f, "*  %s\n", $3);} itensLItens 
    | listas
    ;
%%

int main(int argc, char **argv){
   f = fopen("saida.md", "w"); 
   yyparse();
   fclose(f);
   return 0;
}

yyerror(char *s){
    fprintf(stderr, "error: %s on line %d\n", s,yylineno);
}