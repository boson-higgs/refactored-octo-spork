#include <iostream>
#include <stdio.h>
#include "string"

using namespace std;

class Client
{
private:
    int code;
    string name;

public:
    Client(int c, string n)
    {
        this->code=c;
        this->name=n;
    }

    int GetCode(){return this->code;}
    string GetName(){return this->name;}
};

class AbstractAccount
{
public:
    AbstractAccount()
    {
        cout << "AbstractAccount constructor" << endl;
    }
    virtual ~AbstractAccount()
    {
        cout << "AbstractAccount destructor" << endl;
    }

    virtual bool CanWithdraw(double a) = 0;
};

class Account : public AbstractAccount
{
protected:
    int number;
    double interestRate;

    Client *owner;
    Client *partner;

    double balance;

public:
    Account(int n, Client *o)
    {
        this->number=n;
        this->owner=o;
    }
    Account(int n, Client *o, double ir)
    {
        this->number=n;
        this->owner=o;
        this->interestRate=ir;
    }
    Account(int n, Client *c, Client *p)
    {
        this->number=n;
        this->owner=c;
        this->partner=p;
    }
    Account(int n, Client *c, Client *p, double ir)
    {
        this->number=n;
        this->owner=c;
        this->partner=p;
        this->interestRate=ir;
    }

    virtual ~Account()
    {
        cout << "Account destructor" << endl;
    }

    int GetNumber() {return this->number;}
    double GetBalance(){return this->balance;}
    double GetInterestRate(){return this->interestRate;}
    Client *GetOwner(){return this->owner;}
    Client *GetPartner(){return this->partner;}
    virtual bool CanWithdraw(double a)
    {
        if (a >= GetBalance())
        {
            return true;
        }
        else
            return false;
    }

    void Deposit(double a)
    {
        double b = a + GetBalance();
        this->balance=b;
    }
    bool Withdraw(double a)
    {
        if(CanWithdraw(a) == true)
        {
            double b = GetBalance() - a;
            this->balance=b;
            return true;
        }
        else
            return false;
    }
    void AddInterest();
};

class CreditAccount : public Account
{
private:
    double credit;

public:
    CreditAccount(int n, Client *o, double c) : Account(n,o)
    {
        this->credit=c;
    }
    CreditAccount(int n, Client *o, double ir, double c) : Account(n, o, ir)
    {
        this->credit=c;
    }
    virtual ~CreditAccount()
    {
        cout << "CreditAccount destructor" << endl;
    }

    bool CanWithdraw(double a)
    {
        return (this->GetBalance() + this->credit >= a);
    }

    bool Withdraw(double a)
    {
        bool success = false;
        if(this->CanWithdraw(a))
        {
            this->balance -= a;
            success = true;
        }
        return success;
    }
};


class Objekt
{
public:
    Objekt()
    {
        cout << "Objekt vytvořen" << endl;
    }
    virtual ~Objekt()
    {
        cout <<"Objekt smazán" << endl;
    }
    virtual double Obvod() = 0;
    virtual double Obsah() = 0;
};

class Ctverec : public Objekt
{
protected:
    double a;
public:
    Ctverec(double a)
    {
        this->a = a;
        cout << "Čtverec vytvořen" << endl;
    }
    virtual ~Ctverec()
    {
        cout <<"Čtverec smazán" << endl;
    }
    virtual double Obvod()
    {
        return (4 * this->a);
    }
    virtual double Obsah()
    {
        return (this->a * this->a);
    }
};

class Obdelnik : public Ctverec
{
protected:
    double b;
public:
    Obdelnik(double a, double b) : Ctverec(a)
    {
        this->b = b;
        cout << "Obdélník vytvořen" << endl;
    }
    virtual ~Obdelnik()
    {
        cout <<"Obdélník smazán" << endl;
    }
    double Obvod()
    {
        return ((2 * this->a) + (2 * this->b));
    }
    double Obsah()
    {
        return(this->a * this->b);
    }
};

class Trojuhelnik : public Obdelnik
{
private:
    double c;
    double v;
public:
    Trojuhelnik(double a, double b, double c, double v) : Obdelnik (a,b)
    {
        this->c = c;
        this->v = v;
        cout << "Trojúhelník vytvořen" << endl;
    }
    virtual ~Trojuhelnik()
    {
        cout <<"Trojúhelník smazán" << endl;
    }
    double Obvod()
    {
        return (this->a + this->b + this->c);
    }
    double Obsah()
    {
        return ((this->v * this->a) / 2);
    }
};


int main()
{
    Client *o = new Client(0, "Smith");
    CreditAccount *ca = new CreditAccount(1, o, 1000);

    AbstractAccount *aa = ca;

    delete aa;
    delete o;

    cout << "************************************" << endl;

    Ctverec *square = new Ctverec(2);
    cout << "-----" << endl;
    Obdelnik *rectangle = new Obdelnik(2, 8);
    cout << "-----" << endl;
    Trojuhelnik *triangle = new Trojuhelnik(2, 8, 3, 5);
    cout << "-----" << endl;

    Objekt *object = square;

    cout << square->Obsah() << "   " << square->Obvod() << endl;
    cout << rectangle->Obsah() << "   " << rectangle->Obvod() << endl;
    cout << triangle->Obsah() << "   " << triangle->Obvod() << endl;

    delete square;
    cout << "-----" << endl;
    delete rectangle;
    cout << "-----" << endl;
    delete triangle;

    cout << "-----" << endl;
    delete object;

    return 0;
}
