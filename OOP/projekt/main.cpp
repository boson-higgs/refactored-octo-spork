#include <iostream>
#include <string>
#include <vector>
using namespace std;

class Book
{
private:
    static int count;

    string name;
    string author;
    string ISBN;
    int year;
    string publisher;
    string translator;
    bool is_reserved = false;
    bool is_borrowed = false;

public:
    Book(string name, string author, string ISBN, int year, string publisher)
    {
        this->name = name;
        this->author = author;
        this->ISBN= ISBN;
        this->year;
    }
    Book(string name, string author, string ISBN, int year, string publisher, string translator)
    {
        this->name = name;
        this->author = author;
        this->ISBN= ISBN;
        this->year;
        this->publisher;
    }
    ~Book()
    {
        Book::count--;
    }
    static int GetCount()
    {
        return Book::count;
    }
    string GetISBN()
    {
        return this->ISBN;
    }
    string GetName()
    {
        return this->name;
    }
    void Set_Reserved()
    {
        this->is_reserved = true;
    }
    void Set_Borowed()
    {
        this->is_borrowed = true;
    }
    bool Is_Reserved()
    {
        return this->is_reserved;
    }
    bool Is_Borrowed()
    {
        return this->is_borrowed;
    }
};


class Person
{
    virtual void Registrate() = 0;
};

class Customer : public Person
{
protected:
    int id;
    string name;
    string surname;
    Book* book;
public:
    Customer(int id, string name, string surname) : Person()
    {
        this->id = id;
        this->name = name;
        this->surname = surname;
    }
    int GetID()
    {
        return this->id;
    }
    void Get_Borrowed_Books()
    {
        cout<< this->book<< endl;
    }
    void Reserve(Book* book)
    {
        cout << this->name + " " + this->surname << " si chce zarezervovat " << book->GetName() << endl;

        if(book->Is_Reserved() == false && book->Is_Borrowed() == false)
        {
            book->Set_Reserved();
            cout << "Kniha " << book->GetName() << " " << book->GetISBN() << " zarezervov??na " << endl;
        }
        else
        {
            std::cout << "Kniha " << book->GetName() << " " << book->GetISBN() <<" je ji?? zarezervovan?? nebo p??j??en?? " << endl;
        }
    }
    void Set_Book(Book* bibliograph)
    {
        this->book = bibliograph;
    }

    virtual void Registrate()
    {

    }
};


class Librarian : public Customer
{
public:
    Librarian(int id, string name, string surname) : Customer(id, name, surname)
    {

    }
    void Borrow(Book* book, Customer* customer)
    {
        book->Set_Borowed();
        customer->Set_Book(book);
        cout << "Kniha " << book->GetISBN() << " p??j??ena z??kazn??kovi ????slo " << customer->GetID() << " knihovn??kem " << this->name + " " + this->surname << endl;
    }
};


class Library
{
private:
    vector<Book*> Books;
    vector<Librarian*> Librarians;
    vector<Customer*> Customers;
public:
    void Add_Book(Book* book)//P????d??n?? postavy do t??mu Players
    {
        this->Books.push_back(book);
    }

    void Add_Librarian(Librarian* librarian)//P????d??n?? postavy do t??mu Enemies
    {
        this->Librarians.push_back(librarian);
    }
    void Add_Customer(Customer* customer)
    {
        this->Customers.push_back(customer);
    }

};


using namespace std;

int main()
{
    Library* knihovna = new Library();

    Book* piknik = new Book("Piknik u cesty", "Arkadij a Boris Struga??t??", "23-023-85", 1972, "Mlad?? Fronta", "Antonina W. Bouis");
    Book* fyzika = new Book("Fysika jako dobrodru??stv?? pozn??n??", "Albert Einstein", "80-7299-020-9", 1945, "Dru??stevn?? pr??ce", "Jan Rey");
    Book* katyne = new Book("Katyn??", "Pavel Kohout", "978-80-200-1570-9", 1978, "Samizdatov?? vyd??n??");

    Librarian* karel = new Librarian (1, "Karel", "Bure??");
    Librarian* jarmil = new Librarian (2, "Jarmil", "Mr??zek");

    Customer* oto = new Customer(10, "Oto", "Vintr");
    Customer* borivoj = new Customer(11, "Bo??ivoj", "Tu??ek");

    knihovna->Add_Book(piknik);
    knihovna->Add_Book(fyzika);
    knihovna->Add_Book(katyne);
    knihovna->Add_Librarian(karel);
    knihovna->Add_Librarian(jarmil);
    knihovna->Add_Customer(oto);
    knihovna->Add_Customer(borivoj);


    borivoj->Reserve(fyzika);
    cout << "***********************" << endl;
    oto->Reserve(piknik);
    oto->Reserve(fyzika);
    cout << "***********************" << endl;
    jarmil->Borrow(fyzika, borivoj);
    jarmil->Borrow(piknik, oto);
    cout << "***********************" << endl;
    borivoj->Get_Borrowed_Books();

    return 0;
};