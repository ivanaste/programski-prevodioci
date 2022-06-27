//OPIS: aritmeticke operacije sa pokazivacima

int main() {
    int a;
    int* b;
    a = 20;
    b = &a;
    a = 1 + *b + a;
    return a;
}

