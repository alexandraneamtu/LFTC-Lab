%{
    #include <string.h>
    #include <stdio.h>
    #include <stdlib.h>

    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    extern int yylineno;  // defined and maintained in flex.flex
    extern char *yytext;  // defined and maintained in flex.flex
    extern void printPIF();
    void yyerror(const char *s);
%}

%token CLASS
%token PUBLIC
%token STATIC
%token VOID
%token FFFMAIN
%token STRING
%token ARGS
%token INT
%token READ
%token PRINT
%token IF
%token WHILE
%token ELSE
%token BOOLEAN
%token IDENTIFIER
%token CONSTANT
%token DOUBLE
%token EQ
%token NE
%token LE
%token GE
%%



program :PUBLIC CLASS IDENTIFIER '{' mainfunction '}';
mainfunction : PUBLIC STATIC VOID FFFMAIN '(' STRING '[' ']' ARGS ')' '{' content '}';
content : declarations listofstmt;
declarations : type listvar ';' | type listvar ';' declarations;
listvar : IDENTIFIER | IDENTIFIER ',' listvar;
type : INT | BOOLEAN | DOUBLE;
listofstmt : stmt  | stmt listofstmt;
stmt : assignstmt ';' | inputstmt ';' | outputstmt ';' | condstmt | loopstmt ;
assignstmt : IDENTIFIER  '=' expr | IDENTIFIER '=' expr operator expr;
expr : IDENTIFIER | CONSTANT;
operator : '+'|'-'|'*'|'/'|'>'| NE | EQ | LE | GE;
inputstmt : IDENTIFIER '=' READ '('')';
outputstmt : PRINT'('IDENTIFIER')';
condstmt : IF '(' expr operator expr')' '{' listofstmt '}'| IF'(' expr operator expr')' '{' listofstmt '}' ELSE '{' listofstmt'}';;
loopstmt : WHILE '(' expr operator expr')' '{' listofstmt '}';


//
%%

int main(int argc, char *argv[]) {
    //printf("dsadsadsada\n");
    ++argv, --argc; /* skip over program name */
    if ( argc > 0 ){
        //printf("--------%s",argv[0]);
        yyin = fopen( argv[0], "r" );
    }
    else
        yyin = stdin;
    while (!feof(yyin)) {
        //printf("%s\n", "########");
        yyparse();
    }
    //printPIF();
    printf("%s\n","The program is sintactically correct!!!");
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "%d: error: '%s' at '%s', yylval=%u\n", yylineno, s, yytext, yylval);
    //printPIF();
    exit(1);
}










