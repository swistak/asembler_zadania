#include <stdio.h>
#include <stdint.h>

int asm_strlen(const char*);// __attribute__((ccdl));

int main(void) {
  char to_count[] = "123456789\0";
  size_t x = 0;
  const char * s;

  s = to_count;

  x = asm_strlen(to_count);
  printf("lancuch '%s' ma %d znakow \n", to_count, x);
}


