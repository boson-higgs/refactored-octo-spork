#include <iostream>
using namespace std;

class Order
{

};

class OrderItem
{

};

class AbstractCustomer
{
protected:
    string street;
    string city;
    string postal_code;
    string country;
    Order order;
public:
    AbstractCustomer(string street, string city, string postal_code, string country, Order order)
    {
        this->street = street;
        this->city = city;
        this->postal_code = postal_code;
        this->country = country;
        this->order = order;
    }
};

class UnregisteredUser : public AbstractCustomer
{

};

class AbstractRegisteredCustomer : public AbstractCustomer
{
protected:
    int ID;
public:
    AbstractRegisteredCustomer(int ID, string street, string city, string postal_code, string country, Order order) :  AbstractCustomer(street, city, postal_code, country, order)
    {
        this->ID = ID;
        this->street = street;
        this->city = city;
        this->postal_code = postal_code;
        this->country = country;
        this->order = order;
    }
};

class RegisteredUser : public AbstractRegisteredCustomer
{
private:
    string name;
    string surname;
public:
    RegisteredUser(string name, string surname, int ID, string street, string city, string postal_code, string country, Order order) : AbstractRegisteredCustomer(ID, street, city, postal_code, country, order)
    {
        this->name = name;
        this->surname = surname;
        this->ID = ID;
        this->street = street;
        this->city = city;
        this->postal_code = postal_code;
        this->country = country;
        this->order = order;
    }
};

class CompanyUser : public AbstractRegisteredCustomer
{
protected:
    string company_name;
public:
    CompanyUser(string company_name, int ID, string street, string city, string postal_code, string country, Order order) : AbstractRegisteredCustomer(ID, street, city, postal_code, country, order)
    {
        this->company_name = company_name;
        this->ID = ID;
        this->street = street;
        this->city = city;
        this->postal_code = postal_code;
        this->country = country;
        this->order = order;
    }
};

class AbstractProduct
{
protected:
    int ID;
    int price;
    string brand;
    string model;
    int serial_number;
public:
    AbstractProduct(int ID, int price, string brand, string model, int serial_number)
    {
        this->ID = ID;
        this->price = price;
        this->brand = brand;
        this->model = model;
        this->serial_number = serial_number;
    }

};

class MobilePhone : public AbstractProduct
{
public:
    MobilePhone(int ID, int price, string brand, string model, int serial_number) : AbstractProduct (ID, price, brand, model, serial_number)
    {
    
    }
};

class Notebook : public AbstractProduct
{

};

class Tablet : public AbstractProduct
{

};

int main()
{
    return 0;
}
