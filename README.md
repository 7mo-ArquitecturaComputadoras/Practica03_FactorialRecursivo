# Practica 03 — Factorial Recursivo en Ensamblador x86 (FPU)

## Descripción

Programa en C++ que delega el cálculo del **factorial** a una función implementada en ensamblador x86, haciendo uso de la **Unidad de Punto Flotante (FPU)** mediante instrucciones del coprocesador matemático 80387.

La función implementa el factorial de forma **recursiva**, siguiendo la definición matemática:

```
x! = x * (x-1)!     si x > 1
x! = 1              si x <= 1  (caso base)
```

---

## Estructura del Proyecto

```
Practica03_FactorialRecursivo/
├── main.cpp         # Programa principal: entrada/salida y llamada a la función ASM
└── Factorial.asm    # Implementación recursiva de Mi_fact en ensamblador x86
```

---

## Interfaz entre C++ y Ensamblador

La función se declara en C++ con `extern "C"` para que MASM pueda enlazarla sin decoración de nombres:

```cpp
extern "C" double Mi_fact(double x);
```

### Convención de llamada (`model flat, c`)

El parámetro `double` (64 bits) se pasa por la pila. El valor de retorno se deja en `ST(0)`, que es el mecanismo estándar para devolver `double` en x86 de 32 bits.

| Función   | Parámetro | Ubicación en pila |
|-----------|-----------|-------------------|
| `Mi_fact` | `x`       | `[EBP + 8]`       |

---

## Funcionamiento de Mi_fact

La función sigue el esquema clásico de recursión en pila. En cada llamada se reservan 8 bytes locales (`SUB ESP, 8`) para almacenar temporalmente el valor `x - 1.0` antes de pasarlo como argumento a la siguiente llamada recursiva.

### Flujo de ejecución

```
Mi_fact(x)
 ├─ ¿x <= 1.0? → caso base → retorna 1.0
 └─ x > 1.0   → paso recursivo:
       1. Calcula (x - 1.0) y lo guarda localmente
       2. Llama Mi_fact(x - 1.0)
       3. Multiplica el resultado por x
       4. Retorna x * Mi_fact(x - 1.0)
```

### Ejemplo con x = 4.0

```
Mi_fact(4.0)
 └─ 4.0 * Mi_fact(3.0)
         └─ 3.0 * Mi_fact(2.0)
                  └─ 2.0 * Mi_fact(1.0)
                            └─ caso base → 1.0
                  = 2.0 * 1.0 = 2.0
         = 3.0 * 2.0 = 6.0
 = 4.0 * 6.0 = 24.0  ✓
```

---

## Instrucciones FPU Utilizadas

| Instrucción | Operación |
|-------------|-----------|
| `FLD`       | Carga un `double` desde memoria a la pila FPU |
| `FLD1`      | Carga la constante 1.0 |
| `FCOMIP`    | Compara ST(0) con ST(n), actualiza flags de CPU y saca ST(0) |
| `FSUBP`     | Resta ST(1) - ST(0) y saca ST(0) |
| `FSTP`      | Guarda ST(0) en memoria y lo saca de la pila FPU |
| `FMUL`      | Multiplica dos registros de la pila FPU |

---

## Ejemplo de Ejecución

```
--- Calculadora de Factorial (ASM Recursivo) ---
Introduce un numero: 6
El factorial de 6 es: 720
```

---

## Requisitos

- **Compilador:** MSVC (Visual Studio) con soporte para ensamblado MASM
- **Arquitectura:** x86 (32 bits), modo protegido plano (`flat`)
- **Estándar C++:** C++11 o superior