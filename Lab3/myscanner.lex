/*
lex myscanner.lex
gcc -lfl lex.yy.c
./a.out <program1.txt
*/


%{
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

digit         [0-9]
letter        [a-zA-Z]

%%
"class"                         {   createPIF("class",1);       }
"{"                             {   createPIF("{",2);           }
"}"                             {   createPIF("}",3);           }
"public"                        {   createPIF("public",4);      }
"static"                        {   createPIF("static",5);      }
"void"                          {   createPIF("void",6);        }
"main"                          {   createPIF("main",7);        }
"("                             {   createPIF("(",8);           }
")"                             {   createPIF(")",9);           }
"String"                        {   createPIF("String",10);     }
"["                             {   createPIF("[",11);          }
"]"                             {   createPIF("]",12);          }
"args"                          {   createPIF("args",13);       }
"int"                           {   createPIF("int",14);        }
","                             {   createPIF(";",15);          }
";"                             {   createPIF(";",16);          }
"double"                        {   createPIF("double",17);     }
"="                             {   createPIF("=",18);          }
"read"                          {   createPIF("read",19);       }
"print"                         {   createPIF("print",20);      }
"=="                            {   createPIF("==",21);         }
"!="                            {   createPIF("!=",22);         }
"+"                             {   createPIF("+",23);          }
"-"                             {   createPIF("-",24);          }
"*"                             {   createPIF("*",25);          }
">"                             {   createPIF(">",26);          }
"<"                             {   createPIF("<",27);          }
"<="                            {   createPIF("<=",28);         }
">="                            {   createPIF(">=",29);         }
"/"                             {   createPIF("/",30);          }
"if"                            {   createPIF("if",31);         }
"while"                         {   createPIF("while",32);      }
"else"                          {   createPIF("public",33);     }
{letter}({letter}|{digit})*     {   createPIF(yytext,500);        }
{digit}+                        {   createPIF(yytext,300);        }
[ \t\n\r]
.                               { printf("Unknown character [%c]\n",yytext[0]); return -1;  }
%%

int yywrap(void){
    return 1;
}

int main()
{
    yylex();
    printPIF();
}