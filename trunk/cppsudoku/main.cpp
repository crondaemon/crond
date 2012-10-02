
#include <table.hpp>

int main(int argc, char *argv[])
{
	if (argc < 2) {
		cout << "Usage: " << argv[0] << " <sudoku file>" << endl;
		return 1;
	}

    table t;

    if (!t.load(argv[1]))
        return 2;

    t.print();

    while (t.resolved() == false) {
        int v;

        #ifdef DEBUG
        cout << "Looking for resolvable cells\n";
        #endif

        for (int i = 0; i < 9; i++)
            for (int j = 0; j < 9; j++) {
                v = t.elem(i, j).findVal();
                if (v != 0) t.setVal(v,i,j);
            }

        #ifdef DEBUG
        cout << "Looking for holes in rows/cols/squares" << endl;
        #endif

        for (int i = 0; i < 9; i++)
            t.findHoleInRow(i);
        for (int i = 0; i < 9; i++)
            t.findHoleInCol(i);
        for (int i = 0; i < 9; i++)
            for (int j = 0; j < 9; j++)
                t.findHoleInSquare(i,j);
    }

    t.print();
    cout << "Press ENTER to exit." << endl;
    getchar();
}
