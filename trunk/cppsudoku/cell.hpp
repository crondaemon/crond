
// cell.hpp

#ifndef __CELL_HPP__
#define __CELL_HPP__

#include <iostream>
#include <map>

using namespace std;

class cell {
    int val;
    bool denied[9];
public:
    cell();

    void setVal(int);
    int getVal();

    void deny(int);
    bool isDenied(int);

    int findVal();
};

#endif // __CELL_HPP__
