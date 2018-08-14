#pragma once

class Test {
  public:
    static void set_static_member(int x = 1) {static_member_ = x;}
    static int get_static_member() {return static_member_;}
  private:
    static int static_member_;
};

extern int global_variable;
