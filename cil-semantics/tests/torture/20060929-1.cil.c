/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
void foo(int **p , int *q ) 
{ int **tmp ;
  int *tmp___0 ;
  int *tmp___1 ;

  {
  tmp = p;
  p ++;
  tmp___0 = *tmp;
  (*tmp) ++;
  tmp___1 = q;
  q ++;
  *tmp___0 = *tmp___1;
  return;
}
}
void bar(int **p , int *q ) 
{ int *tmp ;
  int **tmp___0 ;
  int *tmp___1 ;

  {
  tmp = q;
  q ++;
  *(*p) = *tmp;
  tmp___0 = p;
  p ++;
  tmp___1 = *tmp___0;
  (*tmp___0) ++;
  return;
}
}
void baz(int **p , int *q ) 
{ int *tmp ;
  int **tmp___0 ;

  {
  tmp = q;
  q ++;
  *(*p) = *tmp;
  tmp___0 = p;
  p ++;
  (*tmp___0) ++;
  return;
}
}
int main(void) 
{ int i ;
  int j ;
  int *p ;

  {
  i = 42;
  j = 0;
  p = & i;
  foo(& p, & j);
  if ((unsigned long )(p - 1) != (unsigned long )(& i)) {
    abort();
  } else {
    if (j != 0) {
      abort();
    } else {
      if (i != 0) {
        abort();
      }
    }
  }
  i = 43;
  p = & i;
  bar(& p, & j);
  if ((unsigned long )(p - 1) != (unsigned long )(& i)) {
    abort();
  } else {
    if (j != 0) {
      abort();
    } else {
      if (i != 0) {
        abort();
      }
    }
  }
  i = 44;
  p = & i;
  baz(& p, & j);
  if ((unsigned long )(p - 1) != (unsigned long )(& i)) {
    abort();
  } else {
    if (j != 0) {
      abort();
    } else {
      if (i != 0) {
        abort();
      }
    }
  }
  return (0);
}
}