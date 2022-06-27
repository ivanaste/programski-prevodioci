//OPIS: upotreba parametara unutar template funkcije
//RETURN: 21

template <typename T> T saberiSveParametre(T a, T b, T c, T d) {
	int zbir;
	zbir = 1+a+b+c+d;
	return zbir;
} 


int main() {
	int a;
	int b;
	int c;
	int d;
	int rezultat;
	
	a=2;
	b=4;
	c=6;
	d=8;


	rezultat = saberiSveParametre<int>(a, b, c, d);
	return rezultat;
}

