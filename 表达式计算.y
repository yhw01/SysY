%{
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double //yylval $$ ������
#endif

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
//�����ս�������ս����
%left ADD SUB
%left MUL DIV
%right UMINUS
//�������ȼ����ɵ͵��߷ֱ�Ϊ�Ӽ����˳��Լ�ȡ����

%%

// ����β���Ϊ�����﷨�����Ĳ��֣������������޹��ķ�������ģʽ���������ڵĲ��ּ�Ϊ���嶯����
// $$ �������ʽ�󲿵�����ֵ��$n Ϊ����ʽ�Ҳ��� n �� token ������ֵ��
lines   :   lines expr ';' {printf("%f\n", $2);}
        |   lines ';'//����Ҫʵ�ֺ��س�����˿�ʹ�÷ֺ��滻 lines ����ʽ�е� ��\n����
        |
        ;

expr    :   expr ADD expr           {$$ = $1 + $3;}
        |   expr SUB expr           {$$ = $1 - $3;}
        |   expr MUL expr           {$$ = $1 * $3;}
        |   expr DIV expr           {$$ = $1 / $3;}
        |   LEFT expr RIGHT         {$$ = $2;}
        |   SUB expr %prec UMINUS   {$$ = -$2;}//ʹ���������ʽ�еĵ�Ŀ����������б�������������ߵ����ȼ���
        |   NUMBER                  {$$ = $1;}
        ;

%%

int yylex()
{
    int ch;
    while(1) {
        ch = getchar();
        if(ch == ' ' || ch == '\t' || ch =='\n');

        else if (isdigit(ch))//�ȶ����һ��
        {
            yylval = 0;
            while(isdigit(ch))//����ڶ����������ֵĻ�
            {
                yylval = yylval * 10 + ch - '0';
                ch = getchar();
            }
            ungetc(ch, stdin);//�����µ�ch�Żػ�����
            return NUMBER;//��yylval���ظ�NUMBER       ��Ӧ40�еģ� |   NUMBER       {$$ = $1;}
        }
        else if (ch == '+')//ʶ��������ʣ���Ӻţ�
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
        yyparse();//�� main() �е��÷��������� yyparse()
    } while(!feof(yyin));
    return 0;
}

void yyerror(const char* s)// ���󱨸溯�� yyerror()
{
    fprintf(stderr, "Parse error:%s\n", s);
    exit(1);
}