#include <stdio.h>

int strlen(const char*) __attribute__((ccdl));

int main(void) {
  char to_count[] = "123456789";
  int x = 0;

  x = strlen(to_count);
  printf("lancuch '%s' ma %d znakow", to_count, &x);
  
}

