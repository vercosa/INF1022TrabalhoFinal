#include <stdio.h>

int main(void) {
	int X = 0, Y = 0;
	int Z;

	Z=Y;
	while (X) {
		Z++;
	if(Y){
		X=0;
	}

	}

	if(X){
		X=Y;
	}
	else {
		Z=0;
	}

	for(int i=0;i<X;i++){
		Z++;
	}

	printf("%s",Z);
	return 0;
}