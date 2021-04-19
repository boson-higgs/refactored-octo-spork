#include <iostream>
using namespace std;

class KeyValue
{
private:
    int key;
    double value;
    KeyValue *next;
public:
    KeyValue(int k, double v);
    ~KeyValue();
    int GetKey();
    double GetValue();
    KeyValue* GetNext();
    KeyValue* CreateNext(int k, double v);
    void Create(int n);
    void CreateRek(int n);
};
int KeyValue::GetKey()
{
    return this->key;
}
double KeyValue::GetValue()
{
    return this->value;
}
KeyValue::KeyValue(int k, double v)
{
    this->key = k;
    this->value = v;
    this->next = nullptr;
}
KeyValue::~KeyValue()
{
    if(this->next != nullptr)
    {
        delete this->next;
        this->next = nullptr;
    }
}
KeyValue* KeyValue::GetNext()
{
    return this->next;
}
KeyValue* KeyValue::CreateNext(int k, double v)
{
    this->next = new KeyValue(k, v);
    return this->next;
}
void KeyValue::Create(int n)
{
    for(int i; i < n+1; i++)
    {
        KeyValue::CreateNext(5, 10);
    }
}
void KeyValue::CreateRek(int n)
{
    int i = 0;
    KeyValue::CreateNext(5, 10);
    while (i < n+1 )
    {
        return KeyValue::CreateRek(n);
    }
}



class KeyValueString
{
private:
    string key;
    string value;
    KeyValueString* nextL;
    KeyValueString* nextR;

public:
    KeyValueString(string key, string value)
    {
        this->key = key;
        this->value = value;
        this->nextL = nullptr;
        this->nextR = nullptr;
    }
    KeyValueString()
    {
        if (this->nextL != nullptr && this->nextR != nullptr)
        {
            delete this->nextL;
            delete this->nextR;
            this->nextL = nullptr;
            this->nextR = nullptr;
        }
    }
    string GetKey();
    string GetValue();
    KeyValueString* GetNextL();
    KeyValueString* GetNextR();
    KeyValueString* CreateNextL(string key, string value);
    KeyValueString* CreateNextR(string key, string value);
    void MakeElementsR(int count, string key, string value);
    string GetAll();
};
string KeyValueString::GetKey()
{
    return this->key;
}
string KeyValueString::GetValue()
{
    return this->value;
}
KeyValueString* KeyValueString::GetNextL()
{
    return this->nextL;
}
KeyValueString* KeyValueString::GetNextR()
{
    return this->nextR;
}
KeyValueString* KeyValueString::CreateNextL(string key, string value)
{
    this->nextL = new KeyValueString(key, value);
    return this->nextL;
}
KeyValueString* KeyValueString::CreateNextR(string key, string value)
{
    this->nextR = new KeyValueString(key, value);
    return this->nextR;
}
void KeyValueString::MakeElementsR(int count, string key, string value)
{
    --count;
    if(count > 0)
    {
        this->CreateNextL(key, value)->MakeElementsR(count, key, value);
        this->CreateNextR(value, key)->MakeElementsR(count, key, value);
    }
}
string KeyValueString::GetAll()
{
    if(this->GetNextL() != nullptr && this->GetNextR() != nullptr)
    {
        return "{ Key: " + this->GetKey() + ", Value: " + this->GetValue() + ", nextL: " + this->GetNextL()->GetAll() + ", nextR: " + this->GetNextR()->GetAll() + " }";
    }
    else
    {
        return "{ Key: " + this->GetKey() + ", Value: " + this->GetValue() + ", nextL: " + "{ }" + ", nextR: " + "{ }" + " }";
    }
}


class Animal
{
private:
    int legs;
    string name;
    Animal* nextL;
    Animal* nextR;

public:
    Animal(int legs, string name)
    {
        this->legs = legs;
        this->name = name;
        this->nextL = nullptr;
        this->nextR = nullptr;
    }
    Animal()
    {
        if (this->nextL != nullptr && this->nextR != nullptr)
        {
            delete this->nextL;
            delete this->nextR;
            this->nextL = nullptr;
            this->nextR = nullptr;
        }
    }
    Animal* GetNextL();
    Animal* GetNextR();
    Animal* Next(string name);
};
Animal* Animal::GetNextL()
{
    return this->nextL;
}
Animal* Animal::GetNextR()
{
    return this->nextR;
}
Animal* Animal::Next(string name)
{
    if(this->name == "dog")
    {
        Animal(4, "dog").GetNextR();
    }
}



int main()
{
    KeyValue *kv1 = new KeyValue(1, 1.5);
    cout << kv1->CreateNext(2, 2.5)->GetKey() << endl;

    KeyValue* kv2 = kv1->GetNext();
    cout << kv2->GetNext() << endl;

    delete kv1;
    //delete kv2;

    cout << kv1->GetKey() << endl;
    cout << kv2->GetKey() << endl;

    return 0;
}