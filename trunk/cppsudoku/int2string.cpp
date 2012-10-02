
#include "int2string.hpp"
#include <sstream>

std::string to_string(int v)
{
    return static_cast<std::ostringstream*>( &(std::ostringstream() << v))->str();
}
