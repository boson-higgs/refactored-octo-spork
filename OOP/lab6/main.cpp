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
private:
    int number;
    double balance;
    double interestRate;

    Client *owner;
    Client *partner;

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
    bool CanWithdraw(double a)
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

class PartnerAccount : public Account
{
private:
    Client *partner;
public:
    PartnerAccount(int n, Client *o, Client *p) : Account(n, o)
    {
        this->partner = p;
    }
    PartnerAccount(int n, Client *o, Client *p, double ir) : Account(n, o, ir)
    {
        this->partner = p;
    }

    Client *GetPartner()
    {
        return this->partner;
    }
};

class Bank
{
private:
    Client** clients;
    int clientsCount;

    Account **accounts;
    int accountsCount;

public:
    Bank(int c, int a)
    {
        this->clientsCount=c;
        this->accountsCount=a;
    }
    ~Bank();

    Client* GetClient(Client c)
    {
        //return c.GetName();
    }
    Account* GetAccount(int n)
    {
        //return n.GetAccount();
    }

    Client* CreateClient(int c, string n)
    {
        new Client(c, n);
    }
    Account* CreateAccount(int n, Client *c)
    {
        new Account(n, c);
    }
    Account* CreateAccount(int n, Client *c, double ir)
    {
        new Account(n, c, ir);
    }
    Account* CreateAccount(int n, Client *c, Client *p)
    {
        new Account(n, c, p);
    }
    Account* CreateAccount(int n, Client *c, Client *p, double ir)
    {
        new Account(n, c, p, ir);
    }

    void AddInterest();

    PartnerAccount* CreatePartnerAccount(int n, Client *o, Client *p)
    {
        new PartnerAccount(n, o, p);
    }
    PartnerAccount* CreatePartnerAccount(int n, Client *o, Client *p, double ir)
    {
        new PartnerAccount(n, o, p, ir);
    }


};


int main()
{
    Account *a;
    PartnerAccount *pa;
    pa = new PartnerAccount(0, new Client(0, "Smith"), new Client(1, "Jones"));
    a = pa;

    cout << a->GetOwner()->GetName() << endl;
    cout << pa->GetPartner()->GetName() << endl;


    Account *a3;
    PartnerAccount *pa3;
    pa3 = new PartnerAccount(0, new Client(0, "Franta"), new Client(1, "Pepa"));
    a3 = pa3;

    cout << a3->GetOwner()->GetName() << endl;
    cout << pa3->GetPartner()->GetName() << endl;



    Bank *b = new Bank(100, 1000);
    Account *a2;
    Client cl = *new Client(2, "Hopkins");
    Client cli = *new Client(3, "Cooper");
    PartnerAccount *pa2;
    a2 = b->CreateAccount(0, cl);
    pa2 = b->CreatePartnerAccount(1, cl, cli);
    a2 = pa2;
    cout << a2->GetOwner()->GetName() << endl;
    cout << pa2->GetPartner()->GetName() << endl;


    return 0;
}
