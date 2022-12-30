#include <lib.h>

#include <fstream>
#include <iostream>


void lib() {
  std::ifstream file("lib-data.txt");
  std::cout << file.rdbuf();
}
