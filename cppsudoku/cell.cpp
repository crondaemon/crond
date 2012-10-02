
// cell.cpp

#include <cell.hpp>
#include <stdexcept>
#include <sstream>
#include "int2string.hpp"

int cell::getVal()
{
    return val;
}

void cell::setVal(int v)
{
    if (v >= 0 && v < 10) {
        val = v;
        for (int i = 0; i < 9; i++)
            denied[i]=true;
    }
    else
        throw runtime_error("Error in cell::setVal(" +
            to_string(v) + ")");
}

void cell::deny(int v)
{
    if (v == 0)
        return;

    denied[v-1] = true;
}

cell::cell()
{
    val = 0;

    for (int i = 0; i < 9; i++)
        denied[i] = false;
}

int cell::findVal()
{
    int v = 0;
    int count = 0;
    for (int i = 0; i < 9; i++)
        if (denied[i] == false) {
            v = i+1;
            count++;
        }

    if (count == 1)
        return v;

    return 0;
}

bool cell::isDenied(int v)
{
    return denied[v-1];
}
