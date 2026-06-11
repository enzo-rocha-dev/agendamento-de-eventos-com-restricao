# Sistema de agendamento de monitorias do DCM
## Objetivo do sistema

Implementar um sistema de agendamento de monitorias para alunos do Departamento de Computação e Matemática (DCM) em três linguagens:

* Prolog
* Lisp
* Ruby

O sistema deve possuir exatamente as mesmas regras de negócio e dados iniciais em todas as implementações para permitir comparação entre os paradigmas de programação.

---

## Contexto

O sistema simula o agendamento de horários de monitoria entre alunos e professores do DCM da USP Ribeirão Preto.

### Cursos no departamento

* Ciência da Computação
* Informática Biomédica
* Matemática Aplicada a Negócios

### Professores do departamento

| Professor   | Disciplina                |
| ----------- | ------------------------- |
| Tinós       | Estruturas de Dados       |
| Baranauskas | Paradigmas de Programação |
| Joaquim     | Banco de Dados            |

---

## Dados iniciais

### Alunos

| Nome    | Curso | Semestre |
| ------- | ----- | -------- |
| Ana     | MAN   | 3º       |
| Pedro   | BCC   | 5º       |
| Lucas   | IBM   | 2º       |
| Marina  | MAN   | 4º       |
| Júlia   | BCC   | 1º       |
| Gabriel | IBM   | 6º       |

### Horários disponíveis

#### Tinós

* Segunda 14h
* Segunda 15h
* Quarta 14h
* Quarta 15h

#### Baranauskas

* Terça 14h
* Terça 15h
* Quinta 12h
* Quinta 16h

#### Joaquim

* Segunda 16h
* Quarta 16h
* Sexta 14h
* Sexta 15h

### Agendamentos existentes

| Aluno | Professor   | Disciplina                | Dia     | Horário |
| ----- | ----------- | ------------------------- | ------- | ------- |
| Ana   | Tinós       | Estruturas de Dados       | Segunda | 14h     |
| Pedro | Baranauskas | Paradigmas de Programação | Terça   | 14h     |
| Lucas | Joaquim     | Banco de Dados            | Sexta   | 14h     |
| Ana   | Joaquim     | Banco de Dados            | Quarta  | 16h     |

---

## Regras de negócio (deverá ser implementado nas 3 linguagens)

### 1. Disponibilidade do professor

O horário solicitado deve existir na agenda do professor.

Exemplo:

```text
Marina -> Tinós -> Segunda -> 18h
```

Resultado:

```text
Inválido: professor indisponível.
```

---

### 2. Conflito de agenda do professor

Um professor não pode atender dois alunos simultaneamente.

Exemplo:

```text
Ana -> Tinós -> Segunda -> 14h
Marina -> Tinós -> Segunda -> 14h
```

Resultado:

```text
Inválido: horário já ocupado.
```

---

### 3. Conflito de agenda do aluno

Um aluno não pode possuir dois atendimentos simultâneos.

Exemplo:

```text
Ana -> Tinós -> Segunda -> 14h
Ana -> Joaquim -> Segunda -> 14h
```

Resultado:

```text
Inválido: aluno já possui atendimento.
```

---

### 4. Limite semanal

Cada aluno pode possuir no máximo 2 monitorias por semana.

Exemplo:

```text
Ana:
- Segunda 14h
- Quarta 16h

Novo pedido:
Quinta 14h
```

Resultado:

```text
Inválido: limite semanal atingido.
```

---

### 5. Compatibilidade da disciplina

O professor deve ministrar a disciplina solicitada.

Exemplo:

```text
Pedro -> Tinós -> Banco de Dados
```

Resultado:

```text
Inválido: disciplina incompatível.
```

---

## Funcionalidades mínimas

Todas as implementações devem permitir:

* Consultar horários disponíveis de um professor;
* Solicitar um novo agendamento;
* Validar todas as regras de negócio;
* Registrar um novo agendamento válido;
* Informar o motivo da rejeição quando o agendamento for inválido.

---

## Casos de teste (Testes base para as 3 linguagens)

### 1. Caso válido

```text
Marina -> Tinós -> Estruturas de Dados -> Quarta -> 14h
```

Resultado:

```text
Agendamento aprovado.
```

### 2. Professor ocupado

```text
Júlia -> Baranauskas -> Paradigmas de Programação -> Terça -> 14h
```

Resultado:

```text
Inválido: horário já ocupado.
```

### 3. Aluno ocupado

```text
Ana -> Joaquim -> Banco de Dados -> Segunda -> 14h
```

Resultado:

```text
Inválido: aluno já possui atendimento.
```

### 4. Limite semanal

```text
Ana -> Baranauskas -> Paradigmas de Programação -> Quinta -> 14h
```

Resultado:

```text
Inválido: limite semanal atingido.
```

### 5. Disciplina incompatível

```text
Pedro -> Joaquim -> Estruturas de Dados
```

Resultado:

```text
Inválido: disciplina incompatível.
```

---

## Estrutura esperada

Cada implementação deve possuir:

* Cadastro de professores;
* Cadastro de alunos;
* Cadastro de horários disponíveis;
* Cadastro de agendamentos existentes;
* Validação das regras;
* Operação de agendamento.

---

## Extra: Chatbot com NLP

Além das implementações principais em Prolog, Lisp e Ruby, foi desenvolvido um **chatbot interativo com Processamento de Linguagem Natural (NLP)** utilizando Python e PySwip para interpretação com Prolog.

### Objetivo

Este extra tem como intuito demonstrar como o Processamento de Linguagem Natural (NLP) pode ser interpretado e processado utilizando Prolog, permitindo que o sistema de agendamento receba requisições em linguagem natural em vez de seguir um formulário rígido.

### Tecnologias utilizadas

* **Python**: Linguagem principal
* **spaCy**: Processamento de linguagem natural
* **Scikit-learn**: Classificação de intenções com Naive Bayes
* **PySwip**: Integração entre Python e Prolog

### Funcionalidades

O chatbot permite:

* Agendar monitorias através de descrições em linguagem natural;
* Consultar monitorias de um aluno;
* Consultar horários livres de um professor;
* Listar todos os agendamentos;
* Validar intenções e extrair entidades do texto automaticamente.

### Exemplos de uso

```
Entrada: "Ana quer marcar banco de dados com Joaquim quarta às 16h"
Saída: Agendamento aprovado.

Entrada: "Quais são os horários do Tinos na segunda?"
Saída: Segunda 14h, Segunda 15h
```

**Desenvolvido por:** Vibe Coding

---

## Informações sobre o trabalho

### Membros do grupo:

- Giovana Leite
- Murilo Amaral
- Enzo Rocha

Alunos do curso de Ciência da Computação da USP Ribeirão Preto.

Este projeto foi desenvolvido para a disciplina **Linguagens e Paradigmas de Programação**, ministrada pelo Prof. Dr. José Augusto Baranauskas.

O tema escolhido pelo grupo foi: "9. Sistema de Agendamento de Eventos com Restrições. Desenvolver um sistema que permita agendar eventos em um calendário, 
levando em consideração diferentes tipos de restrições, como disponibilidade de recursos, horários preferenciais dos participantes 
e conflitos de agenda."

O objetivo do trabalho é comparar diferentes paradigmas de programação através da implementação de uma mesma solução em Prolog, Lisp e Ruby.
