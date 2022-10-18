%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char idStr[50];
char numStr[50];
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token id
%token add
%token sub
%token mul
%token DIV
%token l_bracket
%token r_barcket
%token NUMBER
%left add sub
%left mul DIV
%right UMINUS

%%
lines   :   lines expr ';' {printf("%s\n", $2);}
        |   lines ';'
	|
        ;

expr    :   expr add expr {$$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$, $1);
                            strcat($$, $3);
                            strcat($$, "+ ");
                          }
        |   expr sub expr {$$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$, $1);
                            strcat($$, $3);
                            strcat($$, "- ");
                          }
        |   expr mul expr{$$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$, $1);
                            strcat($$, $3);
                            strcat($$, "* ");
                          }
        |   l_bracket expr r_barcket  {$$ = $2;}
        |   expr DIV expr{$$ = (char*)malloc(50 * sizeof(char));
                            strcpy($$, $1);
                            strcat($$, $3);
                            strcat($$, "/ ");
                          }
        |   sub expr %prec UMINUS{$$ = (char*)malloc(50 * sizeof(char));
                                    strcpy($$, $2);
                                    strcat($$, "- ");
                                 }
        |   NUMBER {$$ = (char*)malloc(50 * sizeof(char));
                    strcpy($$, $1);
                    strcat($$, " ");
                    }
        |   id {$$ = (char*)malloc(50 * sizeof(char));
                strcpy($$, $1);
                strcat($$, " ");
                }
        ;
%%

int yylex()//ʵ�ִʷ���������
{
    int ch;
    while(1) {
        ch = getchar();
        if(ch == ' ' || ch == '\t' || ch =='\n');

        else if (isdigit(ch))
        /* else if (ch >= '0' && ch <= '9') */
        {
            int ti = 0;
            while(isdigit(ch))
            /* while(ch >= '0' && ch <= '9') */
            {
                numStr[ti] = ch;//��ch�浽numstr��
                ch = getchar();
                ti++;
            }
            numStr[ti] = '\0';//�ַ��������\0
            yylval = numStr;//�����������������ַ���Ϊһ���ַ���, ������ַ����ĵ�ַ���� yylval��
            ungetc(ch, stdin);//���������ֵ�ch���ص�������
            return NUMBER;//NUMBER �ķ���ģʽִ�ж������޸�Ϊ�� yylval��ֵ������ NUMBER,
        }


        else if (isalpha(ch) || ch == '_')//��IDҲ�����ƵĴ���������һ���ַ�Ϊ��ĸ���»���ʱ�����������������ַ���ֱ������һ���������ֻ���ĸ���»��ߵ��ַ�ֹͣ��
        /* else if (ch >= 'a' && ch <= 'z' || ch >='A' && ch <= 'Z' || ch == '_') */
        {
            int ti = 0;
            while(isalpha(ch) || isdigit(ch) || ch == '_')
            /* while(ch >= 'a' && ch <= 'z' || ch >='A' && ch <= 'Z' || ch == '_' || ch >= '0' && ch <= '9' ) */
            {
                idStr[ti] = ch;
                ch = getchar();
                ti++;
            }
            idStr[ti] = '\0';
            yylval = idStr;
            ungetc(ch, stdin);//���� ungetc �����������ķ����ַ���ĸ���»����ַ��Żػ�������
            return ID;
        }
        else if (ch == '+')
        {
            return ADD;
        }
        else if(ch == '-')
        {
            return SUB;
        }
        else if (ch == '*')
        {
            return MUL;
        }
        else if (ch == '/')
        {
            return DIV;
        }
        else if (ch == '(')
        {
            return LEFT;
        }
        else if (ch == ')')
        {
            return RIGHT;
        }
        else
        {
            return ch;
        }
    }
}

int main()
{
    yyin = stdin;
    do {
        yyparse();
    } while(!feof(yyin));
    return 0;
}

void yyerror(const char* s)
{
    fprintf(stderr, "Parse error:%s\n", s);
    exit(1);
}