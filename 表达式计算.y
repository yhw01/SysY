%{
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double //yylval $$ 的类型
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
//声明终结符，非终结符，
%left ADD SUB
%left MUL DIV
%right UMINUS
//三种优先级，由低到高分别为加减、乘除以及取负。

%%

// 规则段部分为进行语法分析的部分，包括上下文无关文法及翻译模式，大括号内的部分即为语义动作。
// $$ 代表产生式左部的属性值，$n 为产生式右部第 n 个 token 的属性值，
lines   :   lines expr ';' {printf("%f\n", $2);}
        |   lines ';'//由于要实现忽回车，因此可使用分号替换 lines 产生式中的 ‘\n’，
        |
        ;

expr    :   expr ADD expr           {$$ = $1 + $3;}
        |   expr SUB expr           {$$ = $1 - $3;}
        |   expr MUL expr           {$$ = $1 * $3;}
        |   expr DIV expr           {$$ = $1 / $3;}
        |   LEFT expr RIGHT         {$$ = $2;}
        |   SUB expr %prec UMINUS   {$$ = -$2;}//使得这个产生式中的单目减运算符具有比其它运算符更高的优先级。
        |   NUMBER                  {$$ = $1;}
        ;

%%

int yylex()
{
    int ch;
    while(1) {
        ch = getchar();
        if(ch == ' ' || ch == '\t' || ch =='\n');

        else if (isdigit(ch))//先读入第一个
        {
            yylval = 0;
            while(isdigit(ch))//如果第二个还是数字的话
            {
                yylval = yylval * 10 + ch - '0';
                ch = getchar();
            }
            ungetc(ch, stdin);//把最新的ch放回缓冲区
            return NUMBER;//把yylval返回给NUMBER       对应40行的： |   NUMBER       {$$ = $1;}
        }
        else if (ch == '+')//识别出各单词（如加号）
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
        yyparse();//在 main() 中调用分析器函数 yyparse()
    } while(!feof(yyin));
    return 0;
}

void yyerror(const char* s)// 错误报告函数 yyerror()
{
    fprintf(stderr, "Parse error:%s\n", s);
    exit(1);
}