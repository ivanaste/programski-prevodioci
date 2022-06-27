//OPIS: upotreba + relacionog operatora umesto <

template +typename T> T saberiSveParametre(T a, T b) {
	int zbir;
	zbir = 30;
	a = zbir + b;
	return a;
} 


int main() {
	int a;
	int b;
	int c;
	unsigned rezultat;
	
	a=2;
	b=4;

	rezultat = saberiSveParametre<int>(a, b, c);
	return a;
}
