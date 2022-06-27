//OPIS: upotreba vise template funkcija sa istim promenljivim
//RETURN: 32

template <typename T> T saberiSveParametre(T a, T b, T c, T d) {
	int rezultat;
	rezultat = a+b+c+d;
	return rezultat;
} 


template <typename T> T uvecajPrviParametar(T a, T b) {
	int rezultat;
	rezultat = 10 + a;
	return rezultat;
} 


int main() {
	int a;
	int b;
	int c;
	int d;
	int rezultat1;
	int rezultat2;
	
	a=2;
	b=4;
	c=6;
	d=8;


	rezultat1 = saberiSveParametre<int>(a, b, c, d);
	rezultat2 = uvecajPrviParametar<int>(a, b);
	return rezultat1+rezultat2;
}

