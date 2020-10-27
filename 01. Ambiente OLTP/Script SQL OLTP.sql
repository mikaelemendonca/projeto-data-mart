
CREATE TRIGGER OLTP.TG_PROCEDIMENTO_UPDATE
ON 
OLTP.TB_PROCEDIMENTO
AFTER UPDATE
AS
DECLARE @ID INT, @V1 NUMERIC(10,2), @V2 NUMERIC(10,2)
DECLARE C_PROCEDIMENTO CURSOR FOR
SELECT ID_PROCEDIMENTO, VALOR FROM DELETED
OPEN C_PROCEDIMENTO 
FETCH C_PROCEDIMENTO INTO @ID, @V2
WHILE (@@FETCH_STATUS = 0)
BEGIN
	SELECT @V1 = VALOR FROM OLTP.TB_PROCEDIMENTO WHERE ID_PROCEDIMENTO = @ID
	IF @V1 <> @V2 
		UPDATE OLTP.TB_PROCEDIMENTO SET ATUALIZADO = 'S', DT_AUDITORIA = GETDATE() WHERE ID_PROCEDIMENTO = @ID
	FETCH C_PROCEDIMENTO INTO @ID, @V2
END
CLOSE C_PROCEDIMENTO 
DEALLOCATE C_PROCEDIMENTO 
 

CREATE TRIGGER OLTP.TG_PRO_AGENDADO_UPDATE
ON 
OLTP.TB_PROC_AGENDADO
AFTER UPDATE
AS
DECLARE @ID INT, @S1 CHAR(2), @S2 CHAR(2)
DECLARE C_PROC_AGENDADO CURSOR FOR
SELECT ID_PROC_AGENDADO, STATUS FROM DELETED
OPEN C_PROC_AGENDADO
FETCH C_PROC_AGENDADO INTO @ID, @S2
WHILE (@@FETCH_STATUS = 0)
BEGIN
	SELECT @S1 = STATUS FROM OLTP.TB_PROC_AGENDADO WHERE ID_PROC_AGENDADO = @ID
	IF @S1 <> @S2 
		UPDATE OLTP.TB_PROC_AGENDADO SET ATUALIZADO = 'S', DT_AUDITORIA = GETDATE() WHERE ID_PROC_AGENDADO = @ID
	FETCH C_PROC_AGENDADO INTO @ID, @S2
END
CLOSE C_PROC_AGENDADO 
DEALLOCATE C_PROC_AGENDADO 


---------------------------


insert into oltp.tb_especialidade values ('clinico geral')
insert into oltp.tb_medico values ('jose da silva', '000x', '000.000.000-00', null, '7999999999', '65412', 'jose', '123', 1)
insert into oltp.tb_medico values ('monalisa de jesus', '111x', '011.100.444-00', null, '711119999', '65452', 'mona', '123', 1)
insert into oltp.tb_procedimento values ('exame de sangue', 55.80, 1, getdate(), 'N')
insert into oltp.tb_procedimento values ('consulta', 205.80, 2, getdate(), 'N')
insert into oltp.tb_clinica values ('razao social','0000000','SE','centro','rua a',100,'49999999')
insert into oltp.tb_secretaria values ('maria costa', '000x', '000.000.000-00', null, '7999999999', 'maria', '123')
insert into oltp.tb_medico_tb_clinica values (1,1,1)
insert into oltp.tb_medico_tb_clinica values (2,1,1)
insert into oltp.tb_agenda values (1, 1, 1)
insert into oltp.tb_agenda values (1, 2, 1)
insert into oltp.tb_dia values (1, getdate())
insert into oltp.tb_dia values (4, getdate())
insert into oltp.tb_paciente values ('mariana santana', '111x', '111.000.111-00', '7999999999', 'SE', 'centro', 'rua a', 100, 'maria', '123')
insert into oltp.tb_paciente values ('joao santana', '555x', '777.000.111-00', '788889999', 'SE', 'centro', 'rua c', 100, 'joao', '123')
insert into oltp.tb_proc_agendado values (1, 1, 'MA', null, null)
insert into oltp.tb_proc_agendado values (2, 1, 'MA', null, null)
insert into oltp.tb_proc_agendado values (2, 2, 'MA', null, null)

update oltp.tb_procedimento set valor = 250.00 where id_procedimento = 1
update oltp.tb_procedimento set nome = 'consulta' where id_procedimento = 1
update oltp.tb_proc_agendado set status = 'CA' where id_proc_agendado = 3
update oltp.tb_proc_agendado set atualizado = 'N' where id_proc_agendado = 5

select * from oltp.tb_procedimento
select * from oltp.tb_proc_agendado
select * from oltp.tb_agenda
select * from oltp.tb_dia
select * from oltp.tb_paciente
select * from oltp.tb_medico
select * from oltp.tb_medico_tb_clinica



---------------------------


CREATE SCHEMA OLTP 


CREATE TABLE OLTP.tb_especialidade (
  id_especialidade INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(45) NOT NULL )


CREATE TABLE OLTP.tb_medico (
  id_medico INT NOT NULL PRIMARY KEY IDENTITY(1,1) ,
  nome VARCHAR(45) NOT NULL,
  rg VARCHAR(25) NOT NULL,
  cpf VARCHAR(14) NOT NULL,
  telefone VARCHAR(20) NULL,
  celular VARCHAR(20) NOT NULL,
  crm VARCHAR(45) NOT NULL,
  login VARCHAR(45) NOT NULL,
  senha VARCHAR(45) NOT NULL,
  tb_especialidade_id_especialidade INT NOT NULL,
  CONSTRAINT fk_tb_medico_tb_especialidade
    FOREIGN KEY (tb_especialidade_id_especialidade)
    REFERENCES OLTP.tb_especialidade (id_especialidade) )
    

CREATE TABLE OLTP.tb_procedimento (
  id_procedimento INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(100) NOT NULL,
  valor NUMERIC(10,2) NOT NULL,
  tb_medico_id_medico INT NOT NULL,
  dt_auditoria DATE NULL,
  atualizado CHAR  NULL,
  CONSTRAINT fk_tb_procedimento_tb_medico
    FOREIGN KEY (tb_medico_id_medico)
    REFERENCES OLTP.tb_medico (id_medico) )

	   
CREATE TABLE OLTP.tb_clinica (
  id_clinica INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  razao_social VARCHAR(100) NOT NULL,
  cnpj VARCHAR(45) NOT NULL,
  estado CHAR(2) NOT NULL,
  bairro VARCHAR(50) NOT NULL,
  logradouro VARCHAR(50) NOT NULL,
  numero INT NULL,
  cep VARCHAR(15) NOT NULL )


CREATE TABLE OLTP.tb_secretaria (
  id_secretaria INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(45) NOT NULL,
  rg VARCHAR(25) NOT NULL,
  cpf VARCHAR(14) NOT NULL,
  telefone VARCHAR(20) NULL,
  celular VARCHAR(20) NOT NULL,
  login VARCHAR(45) NOT NULL,
  senha VARCHAR(45) NOT NULL )


CREATE TABLE OLTP.tb_medico_tb_clinica (
  tb_medico_id_medico INT NOT NULL,
  tb_clinica_id_clinica INT NOT NULL,
  tb_secretaria_id_secretaria INT NOT NULL,
  PRIMARY KEY (tb_medico_id_medico, tb_clinica_id_clinica),
  
  CONSTRAINT fk_tb_medico_tb_clinica_tb_medico
    FOREIGN KEY (tb_medico_id_medico)
    REFERENCES OLTP.tb_medico (id_medico),
  
  CONSTRAINT fk_tb_medico_tb_clinica_tb_clinica
    FOREIGN KEY (tb_clinica_id_clinica)
    REFERENCES OLTP.tb_clinica (id_clinica),
  
  CONSTRAINT fk_tb_medico_tb_clinica_tb_secretaria
    FOREIGN KEY (tb_secretaria_id_secretaria)
    REFERENCES OLTP.tb_secretaria (id_secretaria) )


CREATE TABLE OLTP.tb_agenda (
  id_agenda INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  tb_procedimento_id_procedimento INT NOT NULL,
  tb_medico_tb_clinica_tb_medico_id_medico INT NOT NULL,
  tb_medico_tb_clinica_tb_clinica_id_clinica INT NOT NULL,
  CONSTRAINT fk_tb_agenda_tb_procedimento
    FOREIGN KEY (tb_procedimento_id_procedimento)
    REFERENCES OLTP.tb_procedimento (id_procedimento),
  CONSTRAINT fk_tb_agenda_tb_medico_tb_clinica
    FOREIGN KEY (tb_medico_tb_clinica_tb_medico_id_medico , tb_medico_tb_clinica_tb_clinica_id_clinica)
    REFERENCES OLTP.tb_medico_tb_clinica (tb_medico_id_medico , tb_clinica_id_clinica) )


CREATE TABLE OLTP.tb_dia (
  id_dia INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  tb_agenda_id_agenda INT NOT NULL,
  data DATE NOT NULL,
  CONSTRAINT fk_tb_dia_tb_agenda
    FOREIGN KEY (tb_agenda_id_agenda)
    REFERENCES OLTP.tb_agenda (id_agenda) )


CREATE TABLE OLTP.tb_procedimento_tb_clinica (
  tb_procedimento_id_procedimento INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  tb_clinica_id_clinica INT NOT NULL,
  
  CONSTRAINT fk_tb_procedimento_tb_clinica_tb_procedimento
    FOREIGN KEY (tb_procedimento_id_procedimento)
    REFERENCES OLTP.tb_procedimento (id_procedimento),
  
  CONSTRAINT fk_tb_procedimento_tb_clinica_tb_clinica
    FOREIGN KEY (tb_clinica_id_clinica)
    REFERENCES OLTP.tb_clinica (id_clinica) )


CREATE TABLE OLTP.tb_paciente (
  id_paciente INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  nome VARCHAR(45) NOT NULL,
  rg VARCHAR(25) NOT NULL,
  cpf VARCHAR(14) NOT NULL,
  celular VARCHAR(20) NOT NULL,
  estado CHAR(2) NOT NULL,
  bairro VARCHAR(50) NOT NULL,
  logradouro VARCHAR(50) NOT NULL,
  numero INT NOT NULL,
  login VARCHAR(45) NULL,
  senha VARCHAR(45) NULL )


CREATE TABLE OLTP.tb_paciente_tb_medico_tb_clinica (
  tb_paciente_id_paciente INT NOT NULL,
  tb_medico_tb_clinica_tb_medico_id_medico INT NOT NULL,
  tb_medico_tb_clinica_tb_clinica_id_clinica INT NOT NULL,
  PRIMARY KEY (tb_paciente_id_paciente, tb_medico_tb_clinica_tb_medico_id_medico, tb_medico_tb_clinica_tb_clinica_id_clinica),
  
  CONSTRAINT fk_tb_paciente_tb_medico_tb_clinica_tb_paciente
    FOREIGN KEY (tb_paciente_id_paciente)
    REFERENCES OLTP.tb_paciente (id_paciente),
  
  CONSTRAINT fk_tb_paciente_tb_medico_tb_clinica_tb_medico
    FOREIGN KEY (tb_medico_tb_clinica_tb_medico_id_medico , tb_medico_tb_clinica_tb_clinica_id_clinica)
    REFERENCES OLTP.tb_medico_tb_clinica (tb_medico_id_medico , tb_clinica_id_clinica) )


CREATE TABLE OLTP.tb_clinica_tb_paciente (
  tb_clinica_id_clinica INT NOT NULL,
  tb_paciente_id_paciente INT NOT NULL,
  PRIMARY KEY (tb_clinica_id_clinica, tb_paciente_id_paciente),
  
  CONSTRAINT fk_tb_clinica_tb_paciente_tb_clinica
    FOREIGN KEY (tb_clinica_id_clinica)
    REFERENCES OLTP.tb_clinica (id_clinica),
  
  CONSTRAINT fk_tb_clinica_tb_paciente_tb_paciente
    FOREIGN KEY (tb_paciente_id_paciente)
    REFERENCES OLTP.tb_paciente (id_paciente) )


CREATE TABLE OLTP.tb_proc_agendado (
  id_proc_agendado INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  tb_paciente_id_paciente INT NOT NULL,
  tb_dia_id_dia INT NOT NULL,
  status CHAR(2) NOT NULL CHECK (status IN ('MA', 'CO', 'RE', 'CA')),
  dt_auditoria DATE NULL,
  atualizado CHAR NULL,
  CONSTRAINT fk_tb_proc_agendado_tb_paciente
    FOREIGN KEY (tb_paciente_id_paciente)
    REFERENCES OLTP.tb_paciente (id_paciente),
  CONSTRAINT fk_tb_proc_agendado_tb_dia
    FOREIGN KEY (tb_dia_id_dia)
    REFERENCES OLTP.tb_dia (id_dia) )


CREATE TABLE OLTP.tb_dependente (
  id_dependente INT NOT NULL,
  id_responsavel INT NOT NULL,
  CONSTRAINT fk_tb_dependente_tb_paciente_dependente
    FOREIGN KEY (id_dependente)
    REFERENCES OLTP.tb_paciente (id_paciente),
  CONSTRAINT fk_tb_dependente_tb_paciente_responsavel
    FOREIGN KEY (id_responsavel)
    REFERENCES OLTP.tb_paciente (id_paciente) )


CREATE TABLE OLTP.tb_token (
  id_token INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  token VARCHAR(50) NOT NULL,
  data_aquisicao DATE NOT NULL,
  cpf VARCHAR(14) NOT NULL,
  data_uso DATE NULL,
  tb_medico_id_medico INT NOT NULL,
  CONSTRAINT fk_tb_token_tb_medico
    FOREIGN KEY (tb_medico_id_medico)
    REFERENCES OLTP.tb_medico (id_medico) )


CREATE TABLE OLTP.tb_hora_marcada (
  id_hora INT NOT NULL PRIMARY KEY IDENTITY(1,1),
  hora TIME NOT NULL )


CREATE TABLE OLTP.tb_dia_tb_hora_marcada (
  tb_dia_id_dia INT NOT NULL,
  th_hora_marcada_id_hora INT NOT NULL,
  PRIMARY KEY (tb_dia_id_dia, th_hora_marcada_id_hora),
  
  CONSTRAINT fk_tb_dia_tb_hora_marcada_tb_dia
    FOREIGN KEY (tb_dia_id_dia)
    REFERENCES OLTP.tb_dia (id_dia),
  
  CONSTRAINT fk_tb_dia_tb_hora_marcada_tb_hora_marcada
    FOREIGN KEY (th_hora_marcada_id_hora)
    REFERENCES OLTP.tb_hora_marcada (id_hora) )




	----- ESPECIALIDADE 
	INSERT INTO OLTP.tb_especialidade (nome) VALUES ('Cardiologia')
	INSERT INTO OLTP.tb_especialidade (nome) VALUES ('Nefrologia')
	INSERT INTO OLTP.tb_especialidade (nome) VALUES ('Endoscopia')
	INSERT INTO OLTP.tb_especialidade (nome) VALUES ('Pediatria')
	INSERT INTO OLTP.tb_especialidade (nome) VALUES ('Urologia')


	----- MÉDICO
	INSERT INTO OLTP.tb_medico (nome, rg,cpf,telefone,celular,crm,login,senha,tb_especialidade_id_especialidade) VALUES ('Isaac Rodrigues Ferreira','123456','23117530097','9999999999','9999999999','987654','user1','123456',1)
	INSERT INTO OLTP.tb_medico (nome, rg,cpf,telefone,celular,crm,login,senha,tb_especialidade_id_especialidade) VALUES ('Pietro Martins da Silva Gomes','987654','55645140095','1233333333','1233333333','123469','user2','123456',2)
	INSERT INTO OLTP.tb_medico (nome, rg,cpf,telefone,celular,crm,login,senha,tb_especialidade_id_especialidade) VALUES ('Marianna Martins da Silva Gomes','156975','22469659000','4444444444','4444444444','758256','user3','123456',3)
	INSERT INTO OLTP.tb_medico (nome, rg,cpf,telefone,celular,crm,login,senha,tb_especialidade_id_especialidade) VALUES ('Adam Vitor Dias Porto De Oliveira','852369','78550896080','5555555555','5555555555','888412','user4','123456',4)
	INSERT INTO OLTP.tb_medico (nome, rg,cpf,telefone,celular,crm,login,senha,tb_especialidade_id_especialidade) VALUES ('João Vitor Dias Porto','741123','76008910001','8888888888','8888888888','551155','user5','123456',5)

	--------- PROCEDIMENTO
	INSERT INTO OLTP.tb_procedimento VALUES ('Raio-X',100.5, NULL, 'N')
	INSERT INTO OLTP.tb_procedimento VALUES ('Ultrassom',150.2, NULL, 'N')
	INSERT INTO OLTP.tb_procedimento VALUES ('Colonoscopia',200.3, NULL, 'N')
	INSERT INTO OLTP.tb_procedimento VALUES ('Ecocardiograma',250.1, NULL, 'N')
	INSERT INTO OLTP.tb_procedimento VALUES ('Consulta',50.4, NULL, 'N')
	
	--------- CLINICA
	INSERT INTO OLTP.tb_clinica (razao_social, cnpj,estado,bairro,logradouro,numero,cep) VALUES ('Clinica Itabaiana','1111111111111','SE','Centro','Rua A',10,'44444444')
	INSERT INTO OLTP.tb_clinica (razao_social, cnpj,estado,bairro,logradouro,numero,cep) VALUES ('Clinica Aracaju','22222222222','SE','Centro','Rua B',20,'22222222')
	INSERT INTO OLTP.tb_clinica (razao_social, cnpj,estado,bairro,logradouro,numero,cep) VALUES ('Clinica Socorro','33333333333','BA','Centro','Rua C',30,'99999999')
	INSERT INTO OLTP.tb_clinica (razao_social, cnpj,estado,bairro,logradouro,numero,cep) VALUES ('Clinica Lagarto','44444444444','BA','Centro','Rua A',40,'77777777')

	---------- SECRETARIA
	INSERT INTO OLTP.tb_secretaria (nome, rg,cpf,telefone,celular,login,senha) VALUES ('Maria','1111111111','1111111111','1111111111','1111111111','user11','123456')
	INSERT INTO OLTP.tb_secretaria (nome, rg,cpf,telefone,celular,login,senha) VALUES ('Joana','22222222','22222222','22222222','22222222','user12','123456')
	INSERT INTO OLTP.tb_secretaria (nome, rg,cpf,telefone,celular,login,senha) VALUES ('Pedro','33333333','33333333','33333333','33333333','user13','123456')
	INSERT INTO OLTP.tb_secretaria (nome, rg,cpf,telefone,celular,login,senha) VALUES ('João','44444444','44444444','44444444','44444444','user14','123456')
	INSERT INTO OLTP.tb_secretaria (nome, rg,cpf,telefone,celular,login,senha) VALUES ('Carlos','55555555','55555555','55555555','55555555','user15','123456')

	-------- MEDICO_CLINICA
	INSERT INTO OLTP.tb_medico_tb_clinica (tb_medico_id_medico, tb_clinica_id_clinica,tb_secretaria_id_secretaria) VALUES (1,1,5)
	INSERT INTO OLTP.tb_medico_tb_clinica (tb_medico_id_medico, tb_clinica_id_clinica,tb_secretaria_id_secretaria) VALUES (2,2,4)
	INSERT INTO OLTP.tb_medico_tb_clinica (tb_medico_id_medico, tb_clinica_id_clinica,tb_secretaria_id_secretaria) VALUES (3,3,3)
	INSERT INTO OLTP.tb_medico_tb_clinica (tb_medico_id_medico, tb_clinica_id_clinica,tb_secretaria_id_secretaria) VALUES (4,4,2)
	INSERT INTO OLTP.tb_medico_tb_clinica (tb_medico_id_medico, tb_clinica_id_clinica,tb_secretaria_id_secretaria) VALUES (5,3,1)

	-------- AGENDA
	INSERT INTO OLTP.tb_agenda (tb_procedimento_id_procedimento,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (1,5,3)
	INSERT INTO OLTP.tb_agenda (tb_procedimento_id_procedimento,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (2,2,2)
	INSERT INTO OLTP.tb_agenda (tb_procedimento_id_procedimento,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (3,3,3)
	INSERT INTO OLTP.tb_agenda (tb_procedimento_id_procedimento,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (4,1,1)
	INSERT INTO OLTP.tb_agenda (tb_procedimento_id_procedimento,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (5,4,4)

	-------- DIA
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (1,'20180802')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (1,'20180803')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (1,'20180804')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (1,'20180805')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (1,'20180806')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (2,'20180807')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (2,'20180808')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (2,'20180809')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (2,'20180810')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (2,'20180811')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (3,'20180812')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (3,'20180813')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (3,'20180814')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (3,'20180815')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (4,'20180816')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (4,'20180817')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (4,'20180818')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (4,'20180819')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (4,'20180820')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (5,'20180821')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (5,'20180822')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (5,'20180823')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (5,'20180824')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (5,'20180825')
	INSERT INTO  OLTP.tb_dia(tb_agenda_id_agenda,data) VALUES (5,'20180826')


	---------- PROCEDIMENTO_CLINICA - NAO INSERIU
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (1,1)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (2,1)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (3,1)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (4,1)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (5,1)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (1,2)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (2,2)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (3,2)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (4,3)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (5,3)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (1,3)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (2,4)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (3,4)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (4,4)
	INSERT INTO OLTP.tb_procedimento_tb_clinica (tb_procedimento_id_procedimento, tb_clinica_id_clinica) VALUES (5,4)

	--------- PACIENTE
	INSERT INTO OLTP.tb_paciente (nome, rg,cpf,celular,estado,bairro,logradouro,numero,login,senha) VALUES ('Marcos Dias Porto','23117530097','76008910001','99999999','SE','Centro','Rua A',10,'user6','123456')
	INSERT INTO OLTP.tb_paciente (nome, rg,cpf,celular,estado,bairro,logradouro,numero,login,senha) VALUES ('Vitor Dias Porto De Oliveira','55645140095','78550896080','666666666','SE','Centro','Rua B',20,'user7','123456')
	INSERT INTO OLTP.tb_paciente (nome, rg,cpf,celular,estado,bairro,logradouro,numero,login,senha) VALUES ('Maria Martins Gomes','22469659000','23117530097','77777777','BA','Centro','Rua C',30,'user8','123456')
	INSERT INTO OLTP.tb_paciente (nome, rg,cpf,celular,estado,bairro,logradouro,numero,login,senha) VALUES ('Carlos Rodrigues Ferreira','78550896080','55645140095','66666666','BA','Centro','Rua D',40,'user9','123456')
	INSERT INTO OLTP.tb_paciente (nome, rg,cpf,celular,estado,bairro,logradouro,numero,login,senha) VALUES ('Carlos Martins da Silva Gomes','76008910001','22469659000','55555555','SE','Centro','Rua E',50,'user10','123456')

	--------- PACIENTE_MEDICO_CLINICA - NÃO INSERIU
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (1,1,1)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (2,1,2)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (3,2,3)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (4,2,4)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (5,2,1)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (1,3,2)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (2,3,3)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (3,3,4)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (4,4,1)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (5,4,2)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (1,4,3)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (2,5,4)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (3,5,1)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (4,5,2)
	INSERT INTO OLTP.tb_paciente_tb_medico_tb_clinica (tb_paciente_id_paciente,tb_medico_tb_clinica_tb_medico_id_medico,tb_medico_tb_clinica_tb_clinica_id_clinica) VALUES (5,5,3)

	---------- CLINICA_PACIENTE
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (1,1)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (1,2)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (1,3)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (1,4)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (1,5)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (2,1)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (2,2)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (2,3)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (2,4)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (2,5)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (3,1)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (3,2)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (3,3)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (3,4)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (3,5)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (4,1)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (4,2)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (4,3)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (4,4)
	INSERT INTO OLTP.tb_clinica_tb_paciente (tb_clinica_id_clinica,tb_paciente_id_paciente) VALUES (4,5)

	---------- HORA MARCADA
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('07:00:00')
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('07:30:00')
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('07:40:00')
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('07:50:00')
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('08:00:00')
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('08:10:00')
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('08:40:00')
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('08:50:00')
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('09:00:00')
	INSERT INTO  OLTP.tb_hora_marcada(hora) VALUES ('09:10:00')

	----- TOKEN
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('AABBCC','20180802','76008910001','20180817',1)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('DDEEFF','20180803','78550896080','20180818',2)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('GGHHII','20180804','23117530097','20180819',3)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('JJKKOP','20180805','55645140095','20180820',4)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('DSSFA','20180806','22469659000','20180821',5)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('DSRQW','20180807','23117530097','20180822',1)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('DFD3E','20180808','55645140095','20180823',2)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('Q54QW','20180809','22469659000','20180824',3)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('WEXW','20180810','78550896080','20180825',4)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('WERW','20180811','76008910001','20180826',5)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('VWEW','20180812','55645140095','20180827',1)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('QQER','20180813','22469659000','20180828',2)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('TGFSD','20180814','23117530097','20180829',3)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('DSFGC','20180815','78550896080','20180830',4)
	INSERT INTO OLTP.tb_token (token,data_aquisicao,cpf,data_uso,tb_medico_id_medico) VALUES ('GDWQ','20180816','76008910001','20180831',5)

	---------- PROCEDIMENTO AGENDADO
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (1,1,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (2,1,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (3,1,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (4,1,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (5,2,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (5,3,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (4,4,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (3,5,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (2,6,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (1,3,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (1,6,'MA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (2,11,'CO','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (3,25,'CO','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (4,20,'CO','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (5,17,'CO','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (4,13,'CO','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (2,7,'RE','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (3,21,'CA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (4,17,'CA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (1,12,'CA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (5,10,'CA','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (1,9,'RE','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (1,7,'RE','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (2,5,'RE','N')
	INSERT INTO  OLTP.tb_proc_agendado(tb_paciente_id_paciente,tb_dia_id_dia,status,atualizado) VALUES (3,23,'CA','N')


----- UPDATE PROCEDIMENTO PARA AUDITORIA
UPDATE OLTP.tb_procedimento set valor = 500 where id_procedimento = 1
UPDATE OLTP.tb_procedimento set valor = 100 where id_procedimento = 2
UPDATE OLTP.tb_procedimento set valor = 400 where id_procedimento = 3

------ UPDATE PROC_AGENDADO PARA AUDITORIA
UPDATE OLTP.tb_proc_agendado set status = 'CO' where status = 'MA'
UPDATE OLTP.tb_proc_agendado set status='MA' where status = 'CA'
UPDATE OLTP.tb_proc_agendado set status='CA' where status = 'RE'

