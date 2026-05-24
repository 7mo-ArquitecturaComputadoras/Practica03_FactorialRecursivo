# 🔢 Práctica 03 — Cálculo de Factorial con Recursividad en Ensamblador x86

Programa mixto **ensamblador x86 (MASM) + C++** que calcula el **factorial** de un número real positivo mediante un **algoritmo recursivo con FPU** (*Floating Point Unit*). La función ensambladora `Mi_fact` recibe el argumento como `double` (64 bits), usa la pila de la FPU para comparar, restar y multiplicar en punto flotante, y retorna el resultado en `ST(0)` siguiendo la convención `cdecl`.

---

## 📑 Índice

- [🎯 ¿Qué hace el programa?](#-qué-hace-el-programa)
- [🧠 Idea central del algoritmo](#-idea-central-del-algoritmo)
- [📂 Estructura del repositorio](#-estructura-del-repositorio)
- [🚀 Cómo empezar](#-cómo-empezar)
- [🔍 Trazado del ejemplo `n=5`](#-trazado-del-ejemplo-n5)
- [📘 Instrucciones x86 utilizadas](#-instrucciones-x86-utilizadas)
- [📄 Documentación adicional](#-documentación-adicional)

---

## 🎯 ¿Qué hace el programa?

El programa toma un número real positivo ingresado desde C++ (por ejemplo, `5.0`) y calcula su **factorial de forma recursiva** usando la FPU del procesador:

- El argumento viaja a la función como `double` (64 bits, dos `DWORD` en la pila)
- Cada llamada recursiva reduce el valor en `1.0` hasta el **caso base** (`x ≤ 1.0`)
- Cuando llega al caso base, la FPU retorna `1.0` en `ST(0)`
- Las invocaciones anteriores multiplican sus resultados en cadena con `FMUL`
- El resultado final queda en `ST(0)` al retornar al llamador

El resultado es: `5! = 5.0 × 4.0 × 3.0 × 2.0 × 1.0 = 120.0`

---

## 🧠 Idea central del algoritmo

La función `Mi_fact` usa la **FPU** para todo el cálculo. El argumento se recibe como `QWORD PTR [EBP+8]` (un `double` de 64 bits), y la comparación con el caso base se hace en la pila de la FPU con `FCOMIP`:

```
Mi_fact(x):
    si x <= 1.0
        retornar 1.0             ← FLD1 → ST(0) = 1.0
    si no
        y = x - 1.0              ← FSUBP en FPU
        temp = Mi_fact(y)        ← CALL recursivo (y en pila como QWORD)
        retornar x * temp        ← FMUL QWORD PTR [EBP+8]
```

### Flujo de ejecución (x=5.0)

```
Mi_fact(5.0)
  └─ Mi_fact(4.0)
      └─ Mi_fact(3.0)
          └─ Mi_fact(2.0)
              └─ Mi_fact(1.0)  → CASO BASE: FLD1 → ST(0) = 1.0
              ← FMUL 2.0 → ST(0) = 2.0
          ← FMUL 3.0 → ST(0) = 6.0
      ← FMUL 4.0 → ST(0) = 24.0
  ← FMUL 5.0 → ST(0) = 120.0
```

### Manejo del argumento `double` en la pila

Dado que un `double` ocupa 64 bits, se pasa a la función como dos `DWORD` consecutivos. Dentro de `Mi_fact`, se carga con:

```asm
FLD QWORD PTR [EBP+8]   ; carga el double completo desde la pila a ST(0)
```

Al hacer la llamada recursiva con `(x - 1.0)`, el resultado de `FSUBP` se guarda primero en una variable local `[EBP-8]` con `FSTP QWORD PTR [EBP-8]`, y luego se empuja a la pila en dos partes:

```asm
PUSH DWORD PTR [EBP-4]  ; parte alta del double
PUSH DWORD PTR [EBP-8]  ; parte baja del double
CALL Mi_fact
ADD  ESP, 8             ; limpiar los 8 bytes del argumento
```

---

## 📂 Estructura del repositorio

```
Practica03_FactorialRecursivo/
├── documentacion/
│   ├── README_compilacion_latex.md                  # Cómo compilar el .tex a PDF
│   ├── reporte.pdf                                  # Reporte ya compilado
│   ├── reporte.tex                                  # Reporte técnico en LaTeX
│   └── imagenes/                                    # Imágenes usadas en el reporte
│
├── proyecto/
│   ├── README_instalacion.md                        # Guía de instalación y puesta en marcha
│   ├── Practica03_FactorialRecursivo.slnx           # Solución de Visual Studio
│   ├── Practica03_FactorialRecursivo.vcxproj        # Proyecto MSBuild + MASM
│   └── src/
│       ├── factorial.asm                            # Función Mi_fact en x86 MASM (FPU)
│       └── main.cpp                                 # Interfaz C++ que llama a Mi_fact()
│
├── .gitattributes                                   # Normalización de finales de línea
├── .gitignore                                       # Archivos ignorados por Git
└── README.md                                        # Este archivo
```

---

## 🚀 Cómo empezar

La guía detallada con todos los pasos está en:

➡️ **[Guía de instalación y puesta en marcha](proyecto/README_instalacion.md)**

Resumen rápido para quien ya tiene el entorno listo:

1. Abre el **Símbolo del sistema** (`cmd`) o **Git Bash**, ubícate en la carpeta donde quieras guardar el proyecto y ejecuta:

```bash
git clone git@github.com:7mo-ArquitecturaComputadoras/Practica03_FactorialRecursivo.git
```

2. Abrir `proyecto/Practica03_FactorialRecursivo.slnx` en Visual Studio.
3. Seleccionar configuración **Debug | Win32**.
4. Compilar con `Ctrl + Shift + B` y ejecutar con `Ctrl + F5`.
5. Ingresar el número cuando el programa lo solicite.

---

## 🔍 Trazado del ejemplo `n=5`

### Pila de la FPU por nivel de recursión

| Llamada    | Acción en FPU                               | ST(0) al retornar |
|------------|---------------------------------------------|-------------------|
| Mi_fact(5.0) | `FLD [EBP+8]` → carga 5.0; llama Mi_fact(4.0); `FMUL [EBP+8]` | 120.0 |
| Mi_fact(4.0) | `FLD [EBP+8]` → carga 4.0; llama Mi_fact(3.0); `FMUL [EBP+8]` | 24.0 |
| Mi_fact(3.0) | `FLD [EBP+8]` → carga 3.0; llama Mi_fact(2.0); `FMUL [EBP+8]` | 6.0 |
| Mi_fact(2.0) | `FLD [EBP+8]` → carga 2.0; llama Mi_fact(1.0); `FMUL [EBP+8]` | 2.0 |
| Mi_fact(1.0) | `FCOMIP ST(0),ST(1)` → 1.0 ≥ 1.0 → `JAE caso_base`; `FLD1` | **1.0** |

### Resultado final

`ST(0) = 120.0` → C++ recibe el `double` y lo imprime como `120`

---

## 📘 Instrucciones x86 utilizadas

### FPU (*Floating Point Unit*)

| Instrucción | Operación |
|-------------|-----------|
| `FLD`       | Carga un `double` (64 bits) desde memoria al tope de la pila FPU |
| `FLD1`      | Carga la constante `1.0` al tope de la pila FPU |
| `FCOMIP`    | Compara `ST(0)` con `ST(1)` y hace *pop*; actualiza banderas enteras (ZF, CF, PF) |
| `FSUBP`     | Resta `ST(1) = ST(1) − ST(0)` y hace *pop*; calcula `x − 1.0` |
| `FSTP`      | Guarda `ST(0)` en memoria y hace *pop*; almacena `(x − 1.0)` en variable local |
| `FMUL`      | Multiplica `ST(0)` por el operando de memoria; acumula `resultado × x` |

### Propósito general

| Instrucción    | Operación |
|----------------|-----------|
| `PUSH` / `POP` | Prólogo/epílogo del marco de pila (`EBP`) y paso del argumento `double` (2 × `DWORD`) |
| `MOV`          | Configura el marco de pila (`MOV EBP, ESP`) y restaura el stack (`MOV ESP, EBP`) |
| `SUB`          | Reserva espacio para la variable local de 8 bytes en la pila (`SUB ESP, 8`) |
| `ADD`          | Limpia los 8 bytes del argumento `double` tras la llamada recursiva (`ADD ESP, 8`) |
| `JAE`          | Salta al caso base si `1.0 ≥ x` (resultado de `FCOMIP`) |
| `JMP`          | Salto incondicional desde el bloque recursivo hacia `fin:` |
| `CALL`         | Llama recursivamente a `Mi_fact` |
| `RET`          | Retorna al llamador; el resultado `double` permanece en `ST(0)` |

---

## 📄 Documentación adicional

| Documento | Descripción |
|---|---|
| 🛠️ [`README_instalacion.md`](proyecto/README_instalacion.md) | Cómo instalar Git, Visual Studio con MASM, compilar y ejecutar el programa paso a paso. |
| 📄 [`README_compilacion_latex.md`](documentacion/README_compilacion_latex.md) | Cómo regenerar el PDF del reporte a partir de `reporte.tex` usando TeX Live, Geany o VS Code, tanto en Linux como en Windows. |
| 📕 [`reporte.pdf`](documentacion/reporte.pdf) | Reporte técnico ya compilado, con análisis detallado del algoritmo FPU y el stack de recursión. |
| 📝 [`reporte.tex`](documentacion/reporte.tex) | Fuente LaTeX del reporte técnico. |

---

> **Autor:** Edson Joel Carrera Avila
