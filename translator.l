%option noyywrap yylineno nounput

%{
    #include <stdlib.h>
    #include "translator.tab.h" //tokens do bison
    char string[100];
%}

TEXT [A-Za-z ]*[0-9]*[\:\,\-\.]*

%%

"\\chapter"    {return chapter;}
"\\section"   {return section;}
"\\subsection"    {return subsection;}
"\\paragraph" {return paragraph;}
"\\bf"    {return bf;}
"\\underline" {return underline;}
"\\it"    {eturn it;}
"\\begin" {return begin;}
"\\end" {return end;}
"enumerate" {return enumerate;}
"\\item" {return item;}
"itemize" {return itemize;}
"document" {return document;}
"{" |
"}" {return yytext[0];}
"\\usepackage{"{TEXT}"}"    {yylval.sval = strdup(yytext); return PACOTE;}
"\\author{"{TEXT}"}"  {yylval.sval = strdup(yytext); return AUTOR;}
"\\title{"{TEXT}"}"  {yylval.sval = strdup(yytext); return TITULO;}
"\\documentclass{"{TEXT}"}"    {yylval.sval = strdup(yytext); return CLASSE;}
{TEXT} {yylval.sval = strdup(yytext); return CONTEUDO;}
. ;

%%
