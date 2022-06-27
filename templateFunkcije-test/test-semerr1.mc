//OPIS: upotreba razlicitih tipova argumenata

template <typename T> T saberiSveParametre(T a, T b) {
	int zbir;
	zbir = 30;
	a = zbir + b;
	return a;
} 


int main() {
	int a;
	unsigned b;
	int c;
	int d;
	int rezultat;
	
	a=2;
	b=4U;


	rezultat = saberiSveParametre<int>(a, b);
	return rezultat;
}
