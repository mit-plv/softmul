// needs to be used as &mymem_start
// https://sourceware.org/binutils/docs/ld/Source-Code-Reference.html
// We use "unsigned int" to declare that it's aligned
extern unsigned int mymem_start;

unsigned int fact(unsigned int n) {
  unsigned int res = 1;
  for (unsigned int i = 2; i <= n; i++) res *= i;
  return res;
}

void mymain() {
  unsigned int* mymem = &mymem_start;
  mymem[0] = fact(5);
  mymem[1] = 1;
}
