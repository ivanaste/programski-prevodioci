//OPIS: Dereferenciranje promenljive koja nije pokazivac

int main() {
    int a;
    int* b;
    
    a=5;
    b=&a;
    
    return *a;
}