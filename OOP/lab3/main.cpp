#include <iostream>
#include <string>
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


class KeyValues
{
private:
    KeyValue** keyValues;
    int count;
public:
    KeyValues(int n);
    ~KeyValues();
    KeyValue* CreateObject(int k, double v);
    KeyValue* SearchObject(int key);
    int Count();
    KeyValue* RemoveObject(int k);
};
KeyValues::KeyValues(int n)
{
    this->keyValues = new KeyValue*[n];
    this->count = 0;
}
KeyValues::~KeyValues()
{
    for(int i = 0; i < this->count; i++)
    {
        delete this->keyValues[i];
    }
    delete[] this->keyValues;
}
int KeyValues::Count()
{
    return this->count;
}
KeyValue* KeyValues::CreateObject(int k, double v)
{
    KeyValue *newObject = new KeyValue(k, v);
    this->keyValues[this->count] = newObject;
    this->count += 1;
    return newObject;
}
KeyValue* KeyValues::SearchObject(int k)
{
    for(int i = 0; i < this->count; i++)
    {
        if(this->keyValues[i]->GetKey() == k)
        {
            return this->keyValues[i];
        }
    }
    return nullptr;
}
KeyValue* KeyValues::RemoveObject(int k)
{
    KeyValue* tmp = nullptr;
    for(int i = 0; i < this->count; i++)
    {
        if(this->keyValues[i]->GetKey() == k)
        {
            tmp = this->keyValues[k];
            delete this->keyValues[k];
        }
    }
    return tmp;
}

class Osoba
{
private:
    string jmeno;
    string adresa;
public:
    Osoba(string jmeno, string adresa)
    {
        this->jmeno = jmeno;
        this->adresa = adresa;
    }
};
class PolozkaFaktury
{
private:
    string nazev;
    int cena;
public:
    PolozkaFaktury(string nazev, int cena)
    {
        this->nazev = nazev;
        this->cena = cena;
    }
};
class Faktura
{
private:
    int cislo;
    Osoba osoba(string jmeno, string adresa);
    int pocetPolozek;
    PolozkaFaktury** polozky(string nazev, int cena);
public:
    Faktura(int cislo)
    {
        this->cislo=cislo;
    }
    ~Faktura()
    {

    }
    void UpravOsobu(Osoba osoba)
    {

    }
};
/*
class Faktura
{
    cislo_faktury;
    objekt osoba{
            jmeno;
            adresa;
    };
    pole objektu polozka_faktury{
        nazev;
        cena;
    };
    celkova_cena;

    Konstruktor;
    Destruktor;
    Uprav_osobu;
    Pridat_polozku;
    Uprav_polozku;
    Odstran_polozku;
    Spocitej_celkovou_cenu;
}
*/


int main()
{
    int N = 5;
    KeyValues* myKeyValues = new KeyValues(N);

    KeyValue* myKeyValue = myKeyValues->CreateObject(0, 0.5);
    cout<< myKeyValue->GetValue() << endl;

    for(int i = 1; i < N; i++)
    {
        myKeyValues->CreateObject(i, i + 0.5);
    }
    cout << myKeyValues->SearchObject(4)->GetValue() << endl;

    delete myKeyValues;

    //cout << myKeyValue->GetKey() << endl;

    return 0;
}
