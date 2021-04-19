#include <iostream>
#include <string>
#include <fstream>
using namespace std;

class Osoba
{
protected:
    string jmeno;
    string prijmeni;
public:
    Osoba(string j, string p)
    {
        this->jmeno = j;
        this->prijmeni = p;
    }
    string GetJmeno()
    {
        return this->jmeno;
    }
    string GetPrijmeni()
    {
        return this->prijmeni;
    }
};

/*class Email: public Osoba
{
public:
    Email(string j, string p) : Osoba(j, p)
    {
        this->jmeno = j;
        this->prijmeni = p;
    }
    string GetEmail()
    {
        return this->jmeno + "." + this->prijmeni + "@vsb.cz";
    }
};*/

class Email
{
private:
    string jmeno;
    string prijmeni;
public:
    Email(string j, string p)
    {
        this->jmeno = j;
        this->prijmeni = p;
    }
    string GetEmail()
    {
        return this->jmeno + "." + this->prijmeni + "@vsb.cz";
    }
};

class Dokument
{
private:
    string nazev;
public:
    Dokument(string n)
    {
        this->nazev = n;
    }
    void Zapis()
    {
        ofstream soubor(this->nazev);
        soubor << "Hello world!";
        soubor.close();
    }
    void Cti()
    {
        string text;
        ifstream soubor(this->nazev);
        while (getline (soubor, text))
        {
            cout << text;
        }
        soubor.close();
    }
};

int main()
{
    Osoba o("Franta", "Vomacka");
    cout << o.GetJmeno() + " " + o.GetPrijmeni() << endl;
    Email e("Franta", "Vomacka");
    cout << e.GetEmail() << endl;
    Dokument d("dokument.txt");
    d.Zapis();
    d.Cti();
    return 0;
}
