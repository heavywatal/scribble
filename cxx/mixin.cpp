#include <fmt/base.h>

#include <mutex>
#include <memory>

template <class T>
class Singleton {
  public:
    template <typename... Args>
    static T& instance(Args... args) {
        std::call_once(once_flag_, init<Args...>, std::forward<Args>(args)...);
        return *instance_;
    }

    static void destroy() {
        instance_.reset(nullptr);
    }

  protected:
    Singleton() = default;
    ~Singleton() = default;

  private:
    Singleton(const Singleton&) = delete;
    Singleton& operator=(const Singleton&) = delete;

    template <typename... Args>
    static void init(Args... args) {
        instance_.reset(new T(std::forward<Args>(args)...));
    }

    static std::once_flag once_flag_;
    static std::unique_ptr<T> instance_;
};
template <class T> std::once_flag Singleton<T>::once_flag_;
template <class T> std::unique_ptr<T> Singleton<T>::instance_ = nullptr;

// usage:
//  - public inheritance
//  - private constructor
//  - friend class Singleton<T>;

class Cls : public Singleton<Cls> {
  public:
    const int whoami;
  private:
    Cls(int x): whoami(x) {}
    friend Singleton<Cls>;
};

int main() {
    fmt::println("{}", Cls::instance(24601).whoami);
    fmt::println("{}", Cls::instance(42).whoami);
    return 0;
}
