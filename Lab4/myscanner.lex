/*
bison -d verif.y
lex myscanner.lex
gcc lex.yy.c verif.tab.c -o a
./a <program1.txt
*/


%{
    #include <stdlib.h>
    #include <string.h>
    #include "verif.tab.h"

    int crtpif = 0;
    int crtsym = 0;
    int idx=100;



    struct pifElem{
        int code1;
        int code2;
    };

    struct symElem{
        int wordidx;
        char word[256];
    };

    struct pifElem pif[500];
    struct symElem sym[500];

    int findAddressOf(char *token){
        for (int i=0; i<crtsym; i++)
            if (!strcmp(token, sym[i].word))
                return sym[i].wordidx;
        return -1;
    }


    void createPIF(char* word, int code){
        if(code != 300 && code!= 500){
            pif[crtpif].code1 = code;
            pif[crtpif].code2 = 0;
            crtpif++;
            //printf("%d | -\n", code);
        }
        else{
            if(code == 300 || code == 500){

                int address = findAddressOf(word);
                //printf("address: %d\n",address);
                if (address != -1){
                    pif[crtpif].code1 = code;
                    pif[crtpif].code2 = address;
                    crtpif++;
                }
                else {
                    sym[crtsym].wordidx = idx;
                    strcpy(sym[crtsym].word,word);
                    idx++;
                    pif[crtpif].code1 = code;
                    pif[crtpif].code2 = sym[crtsym].wordidx;
                    crtsym++;
                    crtpif++;
                    //PIFAddress[crtToken++] = crtAddress-1;
                }
                //printf("%d | %d\n", code,idx);
                //idx++;
            }
        }
    }

    void printPIF(){
        printf("-------PIF-------\n");
        for(int i=0;i<crtpif;i++)
        {
            if(pif[i].code2 == 0)
                printf("%d | - \n", pif[i].code1);
            else
                printf("%d | %d \n", pif[i].code1, pif[i].code2);
        }
        printf("\n-------SymTable-------\n");
        for(int i=0;i<crtsym;i++)
        {
            printf("%s | %d \n", sym[i].word, sym[i].wordidx);
        }
    }

%}

%option noyywrap
digit         [0-9]
letter        [a-zA-Z]

%%
"class"                         {   createPIF("class",1);return CLASS;       }
"{"                             {   createPIF("{",2);return '{';           }
"}"                             {   createPIF("}",3);return '}';           }
"public"                        {   createPIF("public",4);return PUBLIC;     }
"static"                        {   createPIF("static",5);return STATIC;      }
"void"                          {   createPIF("void",6);return VOID;        }
"main"                          {   createPIF("main",7);return FFFMAIN;        }
"("                             {   createPIF("(",8);return '(';           }
")"                             {   createPIF(")",9);return ')';           }
"String"                        {   createPIF("String",10);return STRING;     }
"["                             {   createPIF("[",11);return '[';          }
"]"                             {   createPIF("]",12);return ']';          }
"args"                          {   createPIF("args",13);return ARGS;       }
"int"                           {   createPIF("int",14);return INT;        }
","                             {   createPIF(",",15);return ',';          }
";"                             {   createPIF(";",16);return ';';          }
"double"                        {   createPIF("double",17);return DOUBLE;     }
"="                             {   createPIF("=",18);return '=';          }
"read"                          {   createPIF("read",19);return READ;       }
"print"                         {   createPIF("print",20);return PRINT;      }
"=="                            {   createPIF("==",21);return EQ;         }
"!="                            {   createPIF("!=",22);return NE;         }
"+"                             {   createPIF("+",23);return '+';          }
"-"                             {   createPIF("-",24);return '-';          }
"*"                             {   createPIF("*",25);return '*';          }
">"                             {   createPIF(">",26);return '>';          }
"<"                             {   createPIF("<",27);return '<';          }
"<="                            {   createPIF("<=",28);return LE;         }
">="                            {   createPIF(">=",29);return GE;         }
"/"                             {   createPIF("/",30);return '/';          }
"if"                            {   createPIF("if",31);return IF;         }
"while"                         {   createPIF("while",32);return WHILE;      }
"else"                          {   createPIF("else",33);return ELSE;     }
{letter}({letter}|{digit})*     {   createPIF(yytext,500);return IDENTIFIER;        }
{digit}+                        {   createPIF(yytext,300);return CONSTANT;        }
[ \t\n\r]
.                               { printf("Unknown character [%c]\n",yytext[0]); return -1;  }
%%
