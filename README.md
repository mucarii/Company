# Projeto de Banco de Dados - Company

## Descrição do Projeto
Este projeto consiste na criação de um banco de dados para gerenciar informações de uma empresa, incluindo dados de empregados, departamentos, projetos, locais dos departamentos e dependentes. O objetivo é criar um sistema eficiente para armazenar e consultar essas informações.

## Estrutura do Banco de Dados

### Tabelas

- **employee**: Armazena informações sobre empregados.
- **department**: Armazena informações sobre departamentos.
- **dept_locations**: Armazena informações sobre locais dos departamentos.
- **project**: Armazena informações sobre projetos.
- **works_on**: Armazena informações sobre os projetos em que os empregados trabalham.
- **dependent**: Armazena informações sobre os dependentes dos empregados.

### Relacionamentos

- A tabela `employee` tem uma chave estrangeira que referencia a si mesma (Super_ssn).
- A tabela `department` tem uma chave estrangeira que referencia a `employee` (Mgr_ssn).
- A tabela `dept_locations` tem uma chave estrangeira que referencia a `department` (Dnumber).
- A tabela `project` tem uma chave estrangeira que referencia a `department` (Dnum).
- A tabela `works_on` tem chaves estrangeiras que referenciam `employee` (Essn) e `project` (Pno).
- A tabela `dependent` tem uma chave estrangeira que referencia a `employee` (Essn).

## Índices Criados

### Índices e Seus Propósitos

- **Índice `idx_employee_dno_1`**:
  - **Tabela**: `employee`
  - **Coluna**: `Dno`
  - **Tipo**: Índice B-Tree
  - **Motivo**: Melhorar o desempenho das consultas que filtram ou agrupam por `Dno`, como a consulta que retorna o número de empregados por departamento.

- **Índice `idx_dept_locations_dlocation`**:
  - **Tabela**: `dept_locations`
  - **Coluna**: `Dlocation`
  - **Tipo**: Índice B-Tree
  - **Motivo**: Melhorar a performance das consultas que filtram ou ordenam por `Dlocation`, como a consulta que retorna departamentos por cidade.

## Consultas SQL

1. **Qual o departamento com maior número de pessoas?**
   ```sql
   SELECT Dno, COUNT(*) AS num_employees
   FROM employee
   GROUP BY Dno
   ORDER BY num_employees DESC
   LIMIT 1;
2. **Qual o departamento com maior número de pessoas?**
    ```sql
    SELECT d.Dnumber, d.Dname, dl.Dlocation
    FROM department d
    JOIN dept_locations dl ON d.Dnumber = dl.Dnumber
    ORDER BY dl.Dlocation;
3. Relação de empregados por departamento
    ```sql
    SELECT e.Dno, e.Ssn, e.Fname
    FROM employee e
    ORDER BY e.Dno;

## Stored Procedure
## ManageEmployeeData
Objetivo: Permitir inserção, atualização e remoção de dados na tabela employee.
Como usar:
 ```sql
    -- Inserir
CALL ManageEmployeeData(1, '678901234', 'Alice', 'F', '1986-11-23', '303 Pine St', 'F', 72000, '234567890', 2);

-- Atualizar
CALL ManageEmployeeData(2, '678901234', 'Alice Smith', 'F', '1986-11-23', '303 Pine Ave', 'F', 73000, '234567890', 3);

-- Remover
CALL ManageEmployeeData(3, '678901234', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


