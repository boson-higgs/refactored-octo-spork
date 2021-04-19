#include <iostream>
using namespace std;

class KeyValue
{
private:
    int key;
    double value;
public:
    KeyValue(int k, double v);
    int GetKey();
    double GetValue();
};

KeyValue::KeyValue(int k, double v)
{
    this->key = k;
    this->value = v;
}
int KeyValue::GetKey()
{
    return this->key;
}

double KeyValue::GetValue()
{
    return this->value;
}

int main()
{
    KeyValue kv1(1, 1.5);
    cout << kv1.GetValue() << endl;
    KeyValue* kv2 = new KeyValue(2, 2.5);
    cout << kv2->GetValue() << endl;
    delete kv2;
    //getchar();
    return 0;
}

//du - navrhnout tridy, deklarovat -- 3 priklady