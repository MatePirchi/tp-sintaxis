# 💻 Syntax & Semantics: Micro Language Compiler

> *"Compilers are the bridge between human logic and machine execution. This project explores that bridge."*

## 📖 About The Project

This repository contains the practical implementation for the **Syntax & Semantics of Languages** course. The goal is to build a fully functional compiler for the **"Micro" Language** (based on Fischer's definition).

The project demonstrates two distinct engineering approaches to compiler design:
1.  **Manual Implementation:** A recursive descent parser and custom lexical analyzer written in pure C.
2.  **Automated Implementation:** A Bottom-Up parser utilizing **Flex** (Lexical Analysis) and **Bison** (Syntactic Analysis/Yacc).

This duality showcases the evolution from understanding low-level state machines to mastering production-grade parsing tools.

---

## 🏗️ Architecture & Modules

The repository is organized into two main logic blocks:

### 1. `compiladorMicro` (Top-Down / Manual)
* **Approach:** Recursive Descent Parser.
* **Lexer:** Custom state-machine implementation to tokenize the input stream.
* **Parser:** Manual handling of grammar rules (Program, Sentence, Expression).
* **Output:** Generates intermediate code instructions (e.g., `Read`, `Write`, `Store`, `Add`).
* **Language:** C.

### 2. `compilador_ascendente` (Bottom-Up / Tools)
* **Approach:** LALR(1) Parsing.
* **Lexer (`srcFlex.l`):** logic defined using regex patterns to identify tokens (IDs, Constants, Operators).
* **Parser (`srcBison.y`):** Grammar rules defined in BNF format. Handles operator precedence and symbol table management.
* **Key Features:** - Symbol Table (TS) management.
    - Semantic actions embedded in grammar rules.
    - Error reporting (Lexical & Syntactic).

---

## 🛠️ Tech Stack

* **Language:** C (C11 Standard)
* **Tools:** Flex (Fast Lexical Analyzer), Bison (GNU Parser Generator)
* **Scripting:** Bash (for build automation)
* **Environment:** Linux / GCC Compiler

---

## 🚀 Getting Started

### Prerequisites
Ensure you have the standard build tools installed:
```bash
sudo apt-get update
sudo apt-get install gcc flex bison make

```

### Installation & Usage

Clone the repository:

```bash
git clone [https://github.com/YourUsername/tp-sintaxis.git](https://github.com/YourUsername/tp-sintaxis.git)
cd tp-sintaxis

```

#### Option A: Running the Bison/Flex Compiler (Recommended)

We have provided an automation script to generate the C sources, compile, and run the test.

1. Navigate to the folder:
```bash
cd compilador_ascendente

```


2. Run the build script:
```bash
./compilador.sh

```


*This script will compile the grammar, link the lexer, and execute the binary against `prueba1.m`.*

#### Option B: Manual Compilation

If you wish to compile manually:

```bash
bison -yd srcBison.y
lex srcFlex.l
gcc y.tab.c lex.yy.c -o compiler
./compiler prueba1.m

```

---

## 📝 Input Syntax Example (Micro Language)

The compiler accepts files with the `.m` extension. Here is an example of the syntax supported:

```pascal
inicio
    a := 5;
    b := 5 + a;
    c := a - b;
    d := a * b;
    leer(d);
    escribir(c);
fin

```

---

## 👥 Authors & Contributors

* **Juan Jose Tamayo Mazo** 
* **Facundo Soca**
* **Mateo Ezequiel Pirchi**
* **Nicolas Monteiro del Castillo**

---

## ⚖️ License

Distributed under the MIT License. See `LICENSE` for more information.

---

*"Code is like humor. When you have to explain it, it’s bad. Keep it clean."*
