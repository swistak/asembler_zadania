#include <stdio.h>
#include <stdint.h>

int asm_strcmp(const char*, const char*);// __attribute__((ccdl));

int main(void) {
  char a[] = "xaaaa\0";
  char b[] = "xb\0";
  size_t x = 0;
  
  const char * s;

  printf("lancuch '%s' porownany z '%s' ma wynik '%d'\n", a, b, asm_strcmp(a,b));
  printf("lancuch '%s' porownany z '%s' ma wynik '%d'\n", b, a, asm_strcmp(b,a));
  printf("lancuch '%s' porownany z '%s' ma wynik '%d'\n", a, a, asm_strcmp(a,a));
  printf("lancuch '%s' porownany z '%s' ma wynik '%d'\n", b, b, asm_strcmp(b,b));
}


