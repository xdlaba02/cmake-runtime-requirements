#include <base.h>

#include <fstream>
#include <iostream>

void base() {
  std::ifstream file("base-data/base-data.txt");
  std::cout << file.rdbuf();
}
