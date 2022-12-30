#include <fstream>
#include <iostream>

#include <lib.h>
#include <base.h>

int main() {
  lib();
  base();

  std::ifstream file("app-data/app-data.txt");
  std::cout << file.rdbuf();

  return 0;
}
