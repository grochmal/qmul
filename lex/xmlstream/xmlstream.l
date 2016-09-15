/* lexer for xmlstream */
%{
/*#include "xmlstream.tab.h"*/
#define TAG         300
#define ENDTAG      301
#define ENTITY_REF  302
#define ATTR        303
#define ATTRVAL     304
#define PCDATA      305
#define CDATA       306

struct attr_list {
  struct attr_list *next;
  char             *attr;
};
typedef struct attr_list alist;

static alist *attrs;
%}

WSN         [ \t\r\n]
NSTARTCHAR  [^ \t\r\n<&-.0-9]
NCHAR       [^ \t\r\n<&]
NAME        [^ \t\r\n\-><&/!?.0-9=][^ \t\r\n><&=]*

%x attrs
%x cdata
%x comment
%x pcdata

%%

\<!--        { BEGIN (comment); }
"<[CDATA["   { BEGIN (cdata); }
\<![^>]+>     /* ignore declarations */
\<\?[^?]+\?>  /* ignore processing instructions */
\<{NAME}  { BEGIN (attrs); printf ("ATT! (%s)\n", yytext);
             return TAG; }
\<\/{NAME}> { BEGIN (INITIAL); printf ("ATTEND!(%s)\n", yytext);
             return ENDTAG; }

<INITIAL,pcdata>&{NAME};   { return ENTITY_REF; }

<attrs>">"       { BEGIN (pcdata);  printf ("===PCD START (%s)\n", yytext); }
<attrs>"/>"      { BEGIN (INITIAL); printf ("END TAG (%s)\n", yytext); }
<attrs>=         { printf ("EQ (%s)\n", yytext); return '=';      }
<attrs>\".+\"    { printf ("VAL (%s)\n", yytext); return ATTRVAL;  }
<attrs>{NAME}    { printf ("KEY (%s)\n", yytext); return ATTR;     }

<cdata>[^\]]+       { return CDATA;    }
<cdata>\][^\]]+     { return CDATA;    }
<cdata>\]\][^\]>]+  { return CDATA;    }
<cdata>]]>          { BEGIN (INITIAL); }

<comment>[^-]+    /* eat the comment         */
<comment>-[^-]+   /* lone '-', keep eating */
<comment>--[^>]+  /* lone '--', keep eating  */
<comment>-->      { BEGIN (INITIAL); }

<*>{WSN}+        /* ignore whitespace */

<pcdata>[^<]+    { BEGIN (INITIAL); printf ("PCDATA (%s)\n", yytext); return PCDATA; }
<pcdata>\<{NAME}  { BEGIN (attrs); printf ("ATT! (%s)\n", yytext);
                    return TAG; }

%%

int
main (void)
{
  int r = 0;
  while ( (r = yylex ()) > 0 )
    ;  /* keep going */
}

