#ifndef NEU_RESOURCES_H
#define NEU_RESOURCES_H

// for binary file
// by jurt
#ifdef _WIN32
	#define PREV(chunkName,suff) binary_##chunkName##suff
#else
	#define PREV(chunkName,suff) _binary_##chunkName##suff
#endif

#define PREV_START(n) PREV(n,_start)
#define PREV_END(n) PREV(n,_end)
#define PREV_SIZE(n) (&PREV_END(n)-&PREV_START(n))

#define AUTOV(name) \
	extern char PREV_START(name);\
	extern char PREV_END(name);


#include <string>

#include "lib/json/json.hpp"
#include "api/filesystem/filesystem.h"

using namespace std;
using json = nlohmann::json;

namespace resources {

fs::FileReaderResult getFile(const string &filename);
void extractFile(const string &filename, const string &outputFilename);
void init();
void setMode(const string &mode);
string getMode();

} // namespace resources

#endif // #define NEU_RESOURCES_H

