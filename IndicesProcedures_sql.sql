-- Tabela employee
CREATE TABLE IF NOT EXISTS employee (
    Fname VARCHAR(50),
    Minit CHAR(1),
    Ssn CHAR(9) PRIMARY KEY,
    Bdate DATE,
    Address VARCHAR(100),
    Sex CHAR(1),
    Saley DECIMAL(10, 2),
    Super_ssn CHAR(9),
    Dno INT,
    FOREIGN KEY (Super_ssn) REFERENCES employee(Ssn)
);

-- Tabela department
CREATE TABLE IF NOT EXISTS department (
    Dname VARCHAR(50),
    Dnumber INT PRIMARY KEY,
    Mgr_ssn CHAR(9),
    Mgr_start_date DATE,
    FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn)
);

-- Tabela dept_locations
CREATE TABLE IF NOT EXISTS dept_locations (
    Dnumber INT,
    Dlocation VARCHAR(100),
    PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES department(Dnumber)
);

-- Tabela project
CREATE TABLE IF NOT EXISTS project (
    Pname VARCHAR(50),
    Pnumber INT PRIMARY KEY,
    Plocation VARCHAR(100),
    Dnum INT,
    FOREIGN KEY (Dnum) REFERENCES department(Dnumber)
);

-- Tabela works_on
CREATE TABLE IF NOT EXISTS works_on (
    Essn CHAR(9),
    Pno INT,
    hours DECIMAL(5, 2),
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES employee(Ssn),
    FOREIGN KEY (Pno) REFERENCES project(Pnumber)
);

-- Tabela dependent
CREATE TABLE IF NOT EXISTS dependent (
    Essn CHAR(9),
    Dependent_name VARCHAR(50),
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(50),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES employee(Ssn)
);


-- Criação do índice para otimizar a consulta de número de pessoas por departamento
CREATE INDEX idx_employee_dno ON employee(Dno);

-- Criação do índice para otimizar a consulta de departamentos por cidade
CREATE INDEX idx_dept_locations_dlocation ON dept_locations(Dlocation);

-- Qual o departamento com maior número de pessoas?
SELECT Dno, COUNT(*) AS num_employees
FROM employee
GROUP BY Dno
ORDER BY num_employees DESC
LIMIT 1;

-- Quais são os departamentos por cidade?
SELECT d.Dnumber, d.Dname, dl.Dlocation
FROM department d
JOIN dept_locations dl ON d.Dnumber = dl.Dnumber
ORDER BY dl.Dlocation;

-- Relação de empregados por departamento
SELECT e.Dno, e.Ssn, e.Fname
FROM employee e
ORDER BY e.Dno;

DELIMITER //

CREATE PROCEDURE ManageEmployeeData(
    IN action INT,
    IN p_Ssn CHAR(9),
    IN p_Fname VARCHAR(50),
    IN p_Minit CHAR(1),
    IN p_Bdate DATE,
    IN p_Address VARCHAR(100),
    IN p_Sex CHAR(1),
    IN p_Saley DECIMAL(10, 2),
    IN p_Super_ssn CHAR(9),
    IN p_Dno INT
)
BEGIN
    IF action = 1 THEN
        -- Inserir novo empregado
        INSERT INTO employee (Ssn, Fname, Minit, Bdate, Address, Sex, Saley, Super_ssn, Dno)
        VALUES (p_Ssn, p_Fname, p_Minit, p_Bdate, p_Address, p_Sex, p_Saley, p_Super_ssn, p_Dno);
        
    ELSEIF action = 2 THEN
        -- Atualizar informações de um empregado existente
        UPDATE employee
        SET Fname = p_Fname,
            Minit = p_Minit,
            Bdate = p_Bdate,
            Address = p_Address,
            Sex = p_Sex,
            Saley = p_Saley,
            Super_ssn = p_Super_ssn,
            Dno = p_Dno
        WHERE Ssn = p_Ssn;
        
    ELSEIF action = 3 THEN
        -- Remover um empregado
        DELETE FROM employee
        WHERE Ssn = p_Ssn;
        
    ELSE
        -- Caso de erro, ação inválida
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ação inválida';
    END IF;
END //

DELIMITER ;

-- Inserir um novo empregado
CALL ManageEmployeeData(
    1,                    -- Ação: Inserir
    '678901234',          -- SSN
    'Alice',              -- Nome
    'F',                  -- Inicial
    '1986-11-23',         -- Data de Nascimento
    '303 Pine St',        -- Endereço
    'F',                  -- Sexo
    72000,                -- Salário
    '234567890',          -- SSN do Supervisor
    2                     -- Número do Departamento
);

-- Atualizar um empregado existente
CALL ManageEmployeeData(
    2,                    -- Ação: Atualizar
    '678901234',          -- SSN
    'Alice Smith',        -- Novo Nome
    'F',                  -- Nova Inicial
    '1986-11-23',         -- Data de Nascimento
    '303 Pine Ave',       -- Novo Endereço
    'F',                  -- Sexo
    73000,                -- Novo Salário
    '234567890',          -- SSN do Supervisor
    3                     -- Novo Número do Departamento
);

-- Remover um empregado
CALL ManageEmployeeData(
    3,                    -- Ação: Remover
    '678901234',          -- SSN
    NULL,                 -- Nome
    NULL,                 -- Inicial
    NULL,                 -- Data de Nascimento
    NULL,                 -- Endereço
    NULL,                 -- Sexo
    NULL,                 -- Salário
    NULL,                 -- SSN do Supervisor
    NULL                  -- Número do Departamento
);




