%{
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE char*//������Ҫ���ص���һ����׺���ʽ����һ���ַ�������� YYSTYPE������Ϊ char*,
#endif

char numStr[50];//����Ŀ��Ա���NUMBER���ַ���
char idStr[50];//����Ŀ��Ա���ID���ַ���
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char*s);
%}

%token ADD
%token SUB
%token MUL
%token DIV
%token UMINUS
%token LEFT
%token RIGHT
%token NUMBER
%token ID

%left ADD SUB
%left MUL DIV
%right UMINUS

%%
// ����β���Ϊ�����﷨�����Ĳ��֣������������޹��ķ�������ģʽ���������ڵĲ��ּ�Ϊ���嶯����
// $$ �������ʽ�󲿵�����ֵ��$n Ϊ����ʽ�Ҳ��� n �� token ������ֵ��
lines   :   lines expr ';' {printf("%s\n", $2);}
        |   lines ';'
        |
        ;

expr    :   expr ADD expr           {//��ԭ���ļ����Ϊ�ַ�����ƴ��
                                    $$ = (char*) malloc (50*sizeof(char));
                                    strcpy($$, $1);//strcpy($$,$1)Ҳ�ȼ��� strcpy($$,yylval)
                                    strcat($$, $3);//�﷨����������Ҫ������ֵ�޸ĳ��ַ����Ŀ��������ӡ�
                                    strcat($$, "+ ");//תΪ��׺���ʽ
                                    }
        |   expr SUB expr           {
                                    $$ = (char*) malloc (50*sizeof(char));
                                    strcpy($$, $1);
                                    strcat($$, $3);
                                    strcat($$, "- ");
                                    }
        |   expr MUL expr           {
                                    $$ = (char*) malloc (50*sizeof(char));
                                    strcpy($$, $1);
                                    strcat($$, $3);
                                    strcat($$, "* ");
                                    }
        |   expr DIV expr           {
                                    $$ = (char*) malloc (50*sizeof(char));
                                    strcpy($$, $1);
                                    strcat($$, $3);
                                    strcat($$, "/ ");
                                    }
        |   LEFT expr RIGHT         {
                                    $$ = (char*) malloc (50*sizeof(char));
                                    strcpy($$, $2);
                                    strcat($$, " ");
                                    }
        |   SUB expr %prec UMINUS   {
                                    $$ = (char*) malloc (50*sizeof(char));
                                    strcpy($$, "0");
                                    strcat($$, $2);
                                    strcat($$, '-');
                                    }
        |   NUMBER                  {
                                    $$ = (char*) malloc (50*sizeof(char));
                                    strcpy($$, $1);
                                    strcat($$, " ");
                                    }
        |   ID                      {
                                    $$ = (char*) malloc (50*sizeof(char));
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