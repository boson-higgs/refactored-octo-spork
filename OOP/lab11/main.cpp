#include <iostream>
using namespace std;

template<class T>
class BOX
{
private:
    T * instance;
public:
    BOX(T * i)
    {
        this->instance = i;
    }
    T * GetInstance()
    {
        return this->instance;
    }
};

class A
{
private:
    int value;
public:
    A(int v)
    {
        this->value = v;
    }
    int GetValue()
    {
        return this->value;
    }
};

class B : public A
{
public:
    B(int v) : A(v){}
};


const int SIZE = 5;
template <class T>
class Stack
{
    T stack[SIZE];
    int element;

public:
    Stack()
    {
        element = 0;
    }
    void Push(T e)
    {
        if(element==SIZE)
        {
            cout << "Stack is full.\n";
            return;
        }
        stack[element] = e;
        element++;
    }
    T Pop()
    {
        if(element==0)
        {
            cout << "Stack is empty.\n";
            return 0; // return null on empty stack
        }
        element--;
        return stack[element];
    }
};

template <class T>
class Node
{
private:
    T data;
    Node* next;
public:
    void setData(T element)
    {
        data = element;
    }
    void setNext(Node<T>* element)
    {
        next = element;
    }
    T getData(void)
    {
        return data;
    }
    Node* getNext(void)
    {
        return next;
    }
};
template <class T>
class Queue
{
private:
    Node<T>* first;
    Node<T>* last;
    int count;
public:
    Queue(void)
    {
        first = NULL;
        last = NULL;
        count = 0;
    }

    ~Queue(void)
    {
        while(!isEmpty())
            Dequeue();
    }

    void Enqueue(T element)
    {
        Node<T>* tmp = new Node<T>();
        tmp->setData(element);
        tmp->setNext(NULL);

        if (isEmpty()) {
            first = last = tmp;
        }
        else {
            last->setNext(tmp);
            last = tmp;
        }
        count++;
    }

    T Dequeue(void)
    {
        if ( isEmpty() )
            cout << "Queue is empty" << endl;
        T ret = first->getData();
        Node<T>* tmp = first;
        first = first->getNext();
        count--;
        delete tmp;
        return ret;
    }

    T First(void)
    {
        if (isEmpty())
            cout << "Queue is empty" << endl;
        return first->getData();
    }

    int Size(void)
    {
        return count;
    }

    bool isEmpty(void)
    {
        return count == 0 ? true : false;
    }

};

int main()
{
    A * a = new A(50);
    B * b = new B(100);

    BOX<A> * ta = new BOX<A>(a);
    BOX<B> *tb = new BOX<B>(b);

    cout << ta->GetInstance()->GetValue() << endl;
    cout << tb->GetInstance()->GetValue() << endl;

    delete ta;
    delete tb;
    delete a;
    delete b;


    cout <<"*******************************************************" << endl;
    cout << "*********Stack*********" << endl;

    Stack<char> s1, s2;

    s1.Push('a');
    s2.Push('b');
    s1.Push('c');
    s2.Push('d');
    s1.Push('e');

    for(int i=0; i<3; i++)
        cout << "Pop s1: " << s1.Pop() << "\n";
    for(int i=0; i<3; i++)
        cout << "Pop s2: " << s2.Pop() << "\n";

    Stack<double> ds1, ds2;

    ds1.Push(1.1);
    ds2.Push(2.2);
    ds1.Push(3.3);
    ds2.Push(4.4);
    ds1.Push(5.5);

    for(int i=0; i<3; i++)
        cout << "Pop ds1: " << ds1.Pop() << "\n";
    for(int i=0; i<3; i++)
        cout << "Pop ds2: " << ds2.Pop() << "\n";


    return 0;
}
