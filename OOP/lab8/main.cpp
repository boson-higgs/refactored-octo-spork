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


class Account
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

int main()
{
    Client *o = new Client(0, "Smith");
    CreditAccount *ca = new CreditAccount(1, o, 1000);

    cout << ca->CanWithdraw(1000) << endl;

    Account *a = ca;

    cout << a-> CanWithdraw(1000) << endl;
    cout << ca-> CanWithdraw(1000) << endl;

    a = nullptr;
    delete ca;
    delete a;

    return 0;
}
