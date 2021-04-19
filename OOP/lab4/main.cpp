#include <iostream>
#include <stdio.h>
#include <string>

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
    Account(int n, Client *c)
    {
        this->number=n;
        this->owner=c;
    }
    Account(int n, Client *c, double ir)
    {
        this->number=n;
        this->owner=c;
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

    Client* GetClient(int c)
    {
        return Client *GetOwner();
    }
    Account* GetAccount(int n);

    Client* CreateClient(int c, string n)
    {
        new Client(c, n);
    }
    Account* CreateAccount(int n, Client *c)
    {
        
    }
    Account* CreateAccount(int n, Client *c, double ir);
    Account* CreateAccount(int n, Client *c, Client *p);
    Account* CreateAccount(int n, Client *c, Client *p, double ir);

    void AddInterest();
};



int main()
{
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
