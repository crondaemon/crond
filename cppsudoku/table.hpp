
#ifndef __TABLE_HPP__
#define __TABLE_HPP__

#include <fstream>

#include <cell.hpp>

class table {
    cell e[81];
    int nresolv;
public:
    table() : nresolv(0) {};
    cell elem(int,int);
    void setVal(int,int,int);

    bool load(string);

    void denyRow(int,int);
    void denyCol(int,int);
    void denySquare(int,int,int);

    void findHoleInRow(int);
    void findHoleInCol(int);
    void findHoleInSquare(int,int);

    bool resolved();
    void print(bool ext = false);
};

#endif // __TABLE_HPP__
