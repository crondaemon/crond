
#include <table.hpp>
#include <cassert>
#include "int2string.hpp"

cell table::elem(int row, int col)
{
    return e[row * 9 + col];
}

void table::setVal(int val, int row, int col)
{
    if (val == 0)
        return;

#ifdef DEBUG
    cout << "Setting " << val << " in " << row+1 << "," << col+1 << endl;
#endif

    e[row * 9 + col].setVal(val);
    nresolv++;
    denyRow(val, row);
    denyCol(val, col);
    denySquare(val, row, col);
}

void table::denyRow(int val, int row)
{
    assert(val != 0);

#ifdef DEBUG
    cout << "Denying " << val << " in row " << row+1 << endl;
#endif

    for (int i = 0; i < 9; i++)
        e[row * 9 + i].deny(val);
}

void table::denyCol(int val, int col)
{
    assert(val != 0);

#ifdef DEBUG
    cout << "Denying " << val << " in col " << col+1 << endl;
#endif

    for (int i = 0; i < 9; i++)
        e[i * 9 + col].deny(val);
}

void table::denySquare(int val, int row, int col)
{
    assert(val != 0);

    int r = (row / 3) * 3;
    int c = (col / 3) * 3;

#ifdef DEBUG
    cout << "Denying " << val << " in " << r+1 << "," << c+1 << endl;
#endif

    for (int i = r; i < r + 3; i++)
        for (int j = c; j < c + 3; j++)
            e[i * 9 + j].deny(val);
}

bool table::load(string filename)
{
    int v;
    ifstream fs(filename.c_str());

    if (!fs.is_open()) {
        cerr << "Can't open file: " << filename << endl;
        return false;
    }

    for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
            fs >> v;
            setVal(v, i, j);
        }
    }

    return true;
}

bool table::resolved()
{
#ifdef DEBUG
    cout << "Resolved Cells: " << nresolv << "/81" << endl;
#endif

    if (nresolv == 81)
        return true;
    else
        return false;
}

void table::print(bool ext)
{
    for (int i = 0; i < 81; i++) {
        int v = e[i].getVal();
        cout << (v == 0 ? " " : to_string(v));
        if (ext == true) {
            cout << "(";
            for (int j = 1; j <= 9; j++)
                cout << (e[i].isDenied(j) == true ? 1 : 0);
            cout << ")";
        }
        cout << " ";
        if (i%9 == 8)
            cout << endl;
    }
}

void table::findHoleInRow(int row)
{
    int occurr;
    int pos = 0;

    for (int n = 1; n <= 9; n++) {
        occurr = 0;
        for (int i = 0; i < 9; i++)
            if (e[row * 9 + i].isDenied(n) == false) {
                occurr++;
                pos = i;
            }

        if (occurr == 1) {
            setVal(n, row, pos);
        }
    }
}

void table::findHoleInCol(int col)
{
    int occurr;
    int pos = 0;

    for (int n = 1; n <= 9; n++) {
        occurr = 0;
        for (int i = 0; i < 9; i++) {
            if (e[i * 9 + col].isDenied(n) == false) {
                occurr++;
                pos = i;
            }
        }

        if (occurr == 1)
            setVal(n, pos, col);
    }
}

void table::findHoleInSquare(int row, int col)
{
	int occurr;
	int posX=0, posY=0;
	int startX = (row / 3) * 3;
    int startY = (col / 3) * 3;

	for (int n = 1; n <= 9; n++) {
		occurr = 0;
		for (int i = startX; i < 3; i++)
			for (int j = startY; j < 3; j++)
				if (e[i*9+j].isDenied(n) == false) {
					occurr++;
					posX = i;
					posY = j;
				}

		if (occurr == 1)
			setVal(n, posX, posY);
	}
}
