# 🔢 Práctica 03 — Cálculo de Factorial con Recursividad en Ensamblador x86

Programa escrito en **ensamblador x86 (MASM)** con interfaz en **C++** que calcula el **factorial** de un número mediante un **algoritmo recursivo puro**, operando directamente sobre los registros del procesador, sin usar funciones externas de librerías estándar.

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

El programa toma un número entero declarado en la sección `.data` (por ejemplo, `n = 5`) y calcula su **factorial de forma recursiva** mediante llamadas de función encadenadas que construyen un stack de activación:

- Cada invocación recursiva decrementa el número
- Cuando llega al **caso base** (`n = 0` o `n = 1`), retorna `1`
- Las invocaciones anteriores multiplican sus resultados en cadena
- El resultado final se almacena en un registro o variable en memoria

El resultado es un cálculo puro recursivo: `5! = 5 × 4 × 3 × 2 × 1 = 120`, todo operando sobre la pila (stack) del procesador.

---

## 🧠 Idea central del algoritmo

Aprovecha el **mecanismo de llamadas de función** (CALL/RET) para manejar recursividad. Cada nivel de recursión almacena su estado en el stack mediante PUSH/POP:

```
Factorial(n):
    si n <= 1
        retornar 1
    si no
        temp = Factorial(n - 1)
        retornar n * temp
```

### Flujo de ejecución (n=5)

```
Factorial(5)
  └─ Factorial(4)
      └─ Factorial(3)
          └─ Factorial(2)
              └─ Factorial(1)  → CASO BASE, retorna 1
              ← retorna 2*1 = 2
          ← retorna 3*2 = 6
      ← retorna 4*6 = 24
  ← retorna 5*24 = 120
```

---

## 📂 Estructura del repositorio

```
Practica03_FactorialRecursivo/
├── documentacion/
│   ├── README_compilacion_latex.md                  # Cómo compilar el .tex a PDF
│   ├── reporte.pdf                                  # Reporte ya compilado
│   ├── reporte.tex                                  # Reporte técnico en LaTeX
│   └── imagenes/
│       ├── call_stack.png
│       ├── consola.png
│       └── registros.png
│
├── proyecto/
│   ├── README_instalacion.md                        # Guía de instalación y puesta en marcha
│   ├── Practica03_FactorialRecursivo.slnx           # Solución de Visual Studio
│   ├── Practica03_FactorialRecursivo.vcxproj        # Proyecto MSBuild + MASM
│   └── src/
|       ├── factorial.asm                            # Función recursiva en x86 MASM
|       └── main.cpp                                 # Interfaz C++ que llama a factorial()
│
├── .gitattributes                                   # Normalización de finales de línea
├── .gitignore                                       # Archivos ignorados por Git
└── README.md                                        # Este archivo
```

---

## 🚀 Cómo empezar

La guía detallada con todos los pasos está en:

➡️ **[Guía de instalación y puesta en marcha](proyecto/README_instalacion.md)**

Resumen rápido:

1. `git clone <url-del-repositorio>`
2. Abrir `proyecto/Practica03_FactorialRecursivo.slnx` en Visual Studio
3. Seleccionar **Debug | Win32**
4. Compilar con `Ctrl + Shift + B` y ejecutar con `F5`

---

## 🔍 Trazado del ejemplo `n=5`

| Función | n | Caso Base | Retorna |
|---------|---|-----------|---------|
| Factorial(5) | 5 | No | 5 × Factorial(4) |
| Factorial(4) | 4 | No | 4 × Factorial(3) |
| Factorial(3) | 3 | No | 3 × Factorial(2) |
| Factorial(2) | 2 | No | 2 × Factorial(1) |
| Factorial(1) | 1 | **Sí** | **1** |
| ← Factorial(2) | | | 2 × 1 = **2** |
| ← Factorial(3) | | | 3 × 2 = **6** |
| ← Factorial(4) | | | 4 × 6 = **24** |
| ← Factorial(5) | | | 5 × 24 = **120** |

Resultado final: **120**

---

## 📘 Instrucciones x86 utilizadas

| Instrucción | Operación |
|-------------|-----------|
| `CALL` | Llama a un procedimiento |
| `RET` | Retorna de un procedimiento |
| `PUSH` | Empuja valor a la pila |
| `POP` | Saca valor de la pila |
| `CMP` | Compara dos valores |
| `JLE` / `JG` | Saltos condicionales |
| `MOV` | Copia un valor |
| `IMUL` | Multiplicación entera |
| `SUB` | Resta |

---

## 📄 Documentación adicional

| Documento | Descripción |
|---|---|
| 🛠️ [`README_instalacion.md`](proyecto/README_instalacion.md) | Instalación y compilación paso a paso |
| 📄 [`README_compilacion_latex.md`](documentacion/README_compilacion_latex.md) | Cómo compilar el reporte desde LaTeX |
| 📕 [`reporte.pdf`](documentacion/reporte.pdf) | Reporte técnico compilado |

---

> **Autor:** Edson Joel Carrera Avila
