#include <string>
using namespace std;
#ifndef LAB6_ANIMAL_H
#define LAB6_ANIMAL_H


class Animal {
private:
    int legs;
    string name;

public:
    Animal(int l, string n)
    {
        this->legs = l;
        this->name = n;
    }

};


#endif //LAB6_ANIMAL_H

class Dog : public Animal
private:
    string kind;
public:
    Dog(k, l, n) : Animal(l, n)

};
