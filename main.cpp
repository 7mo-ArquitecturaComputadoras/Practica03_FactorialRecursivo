// ============================================================
// Autor: Edson Joel Carrera Avila
// main.cpp
// ============================================================

#include <iostream>

using namespace std;

extern "C" double Mi_fact(double x);

int main() {
    double numero;

    cout << "--- Calculadora de Factorial (ASM Recursivo) ---" << endl;
    cout << "Introduce un numero: ";
    cin >> numero;

    double resultado = Mi_fact(numero);
    cout << "El factorial de " << numero << " es: " << resultado << endl;

    return 0;
}