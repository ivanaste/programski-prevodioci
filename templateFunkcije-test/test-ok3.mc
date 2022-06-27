//OPIS: pozivi template funkcije sa razlicitim tipom
//RETURN: 14

template <typename T> T saberiSveParametre(T a, T b) {
	return a+b;
} 


unsigned main() {
	int a;
	int b;
	unsigned c;
	unsigned d;
	int rezultat1;
	unsigned rezultat2;
	
	a=2;
	b=4;
	c=6U;
	d=8U;


	rezultat1 = saberiSveParametre<int>(a, b);
	rezultat2 = saberiSveParametre<unsigned>(c, d);
	return rezultat2;
}

