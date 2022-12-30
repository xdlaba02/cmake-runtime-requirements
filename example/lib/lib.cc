#include <lib.h>

#include <fstream>
#include <iostream>


void lib() {
  std::ifstream file("lib-additional-data.txt");
  std::cout << file.rdbuf();

  std::ifstream file2("lib-data/lib-data.txt");
  std::cout << file2.rdbuf();
}
