#include <unistd.h> // chdir, getcwd, unlink, access, getpid, gethostname
#include <dirent.h> // opendir
#include <sys/stat.h> // mkdir, stat

#include <cerrno>
#include <cstdio> // remove
#include <cstdlib> // getenv

#include <string>
#include <fstream>
#include <vector>
#include <iostream>

/////////1/////////2/////////3/////////4/////////5/////////6/////////7/////////
namespace wtl {

inline std::string basename(const std::string& path) {
    size_t pos = path.find_last_of('/');
    return path.substr(++pos);
}

inline std::string dirname(const std::string& path) {
    size_t pos = path.find_last_of('/');
    if (pos == std::string::npos) return ".";
    return path.substr(0, pos);
}

inline bool exists(const std::string& target) {return !::access(target.c_str(), F_OK);}
inline bool can_read(const std::string& target) {return !::access(target.c_str(), R_OK);}
inline bool can_write(const std::string& target) {return !::access(target.c_str(), W_OK);}

inline bool isfile(const std::string& target) {
    struct stat buf;
    return !::stat(target.c_str(), &buf) && S_ISREG(buf.st_mode);
}

inline bool isdir(const std::string& target) {
    struct stat buf;
    return !::stat(target.c_str(), &buf) && S_ISDIR(buf.st_mode);
}

inline std::string getenv(const std::string& s) {
    const char* cstr = std::getenv(s.c_str());
    if (cstr) {
        return std::string(cstr);
    } else {
        return std::string{};
    }
}

inline std::string gethostname() {
    constexpr unsigned int bufsize = 80;
    char hostname[bufsize];
    ::gethostname(hostname, bufsize);
    return std::string(hostname);
}

inline std::string pwd() {
    char dir[1024];
    if (::getcwd(dir, sizeof(dir))) {
        return std::string(dir);
    }
    std::perror(dir);
    throw std::runtime_error(dir);
}

inline void cd(const std::string& dir) {
    if (::chdir(dir.c_str())) {
        std::perror(dir.c_str());
        throw std::runtime_error(dir);
    }
}

inline std::vector<std::string>
ls(const std::string& dir=".", const bool all=false) {
    DIR* dirp = opendir(dir.c_str());
    if (!dirp) {
        std::perror(dir.c_str());
        throw std::runtime_error(dir);
    }
    struct dirent* entp;
    std::vector<std::string> dst;
    while ((entp=readdir(dirp))) {
        // ignore '.' and '..'
        if (!strcmp(entp->d_name, ".\0") || !strcmp(entp->d_name, "..\0")) continue;
        // other dot files are depending on the flag
        if (*(entp->d_name) == '.' && !all) continue;
        dst.push_back(entp->d_name);
    }
    closedir(dirp);
    return dst;
}

inline void rm(const std::string& target) {
    if (std::remove(target.c_str())) {
        std::perror(target.c_str());
        throw std::runtime_error(target);
    }
}

inline int mv(const std::string& src, std::string dst, const bool force=false) {
    if (isdir(dst)) {
        dst = dst + "/" + basename(src);
    }
    if (exists(dst) && !force) {
        std::perror(dst.c_str());
        throw std::runtime_error(dst);
    }
    const int status(rename(src.c_str(), dst.c_str()));
    if (status) {
        std::perror((src + ", " + dst).c_str());
        throw std::runtime_error(src + ", " + dst);
    }
    return status;
}

inline void ln(const std::string& src, const std::string& dst, const bool force=false) {
    if (exists(dst) && force) {
        rm(dst);
    }
    if (symlink(src.c_str(), dst.c_str())) {
        std::perror(dst.c_str());
        throw std::runtime_error(dst);
    }
}

inline int mkdir(const std::string& dir) {
    const int status(::mkdir(dir.c_str(), 0755));
    if (status && errno != EEXIST) {
        std::perror(dir.c_str());
        throw std::runtime_error(dir);
    }
    return status;
}

inline unsigned int dev_urandom() {
    unsigned int x;
    try {
        std::ifstream fin("/dev/urandom", std::ios::binary | std::ios::in);
        fin.exceptions(std::ios::failbit | std::ios::badbit);
        fin.read(reinterpret_cast<char*>(&x), sizeof(x));
    }
    catch (std::ios::failure& e) {throw std::ios::failure("/dev/urandom");}
    return x;
}

} // namespace wtl
/////////1/////////2/////////3/////////4/////////5/////////6/////////7/////////

int main() {
    std::cout << wtl::dev_urandom() << "\n";
    std::cout << wtl::gethostname() << "\n";
    std::cout << wtl::getenv("HOME") << "\n";
    std::cout << wtl::pwd() << "\n";
    std::cout << wtl::dirname(wtl::pwd()) << "\n";
    std::cout << wtl::basename(wtl::pwd()) << "\n";
    for (const auto& x: wtl::ls()) {
        std::cout << x;
        if (wtl::isdir(x)) {
            std::cout << "/ ";
        } else {
            std::cout << " ";
        }
    }
    std::cout << "\n";
    return 0;
}
