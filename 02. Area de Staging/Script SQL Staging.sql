-------------- TABELAS AREA DE STAGING

USE teste

CREATE SCHEMA STG


CREATE TABLE STG.aux_tempo (
  data_carga DATE NOT NULL,
  idaux_tempo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  nivel varchar(8) NOT NULL,
  data DATE NULL,
  dia INT NULL,
  dia_semana varchar(25) NULL,
  dia_util char(3) NULL,
  feriado char(3) NULL,
  fim_semana char(3) NULL,
  mes INT NULL,
  nome_mes varchar(20) NULL,
  semestre INT NULL,
  nome_semestre varchar(20) NULL,
  ano INT NULL )


CREATE TABLE STG.aux_procedimento (
  data_carga DATE NOT NULL,
  idaux_procedimento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  id_procedimento INT NULL,
  nome VARCHAR(45) NULL,
  valor FLOAT NULL,
  dt_auditoria DATE NULL,
  atualizado CHAR  NULL )


CREATE TABLE STG.aux_clinica (
  data_carga DATE NOT NULL,
  idaux_clinica INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  id_clinica INT NULL,
  razao_social VARCHAR(45) NULL,
  cnpj VARCHAR(45) NULL )


CREATE TABLE STG.aux_medico (
  data_carga DATE NOT NULL,
  idaux_medico INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  id_medico INT NULL,
  nome VARCHAR(45) NULL,
  crm VARCHAR(45) NULL,
  especialidade VARCHAR(45) NULL )


CREATE TABLE STG.aux_status (
  data_carga DATE NOT NULL,
  idaux_status INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  nome CHAR(2) NULL )


-- tirar duvida
CREATE TABLE STG.fato_agendamento (
  data_carga DATE NOT NULL,
  idfato_agendamento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  id_proc_agendado INT NOT NULL,
  idaux_tempo INT NULL,
  id_procedimento INT NULL,
  id_clinica INT NULL,
  id_medico INT NULL,
  idaux_status INT NULL,
  quantidade INT NULL,
  dt_auditoria DATE NULL,
  atualizado CHAR NULL )

CREATE TABLE STG.fato_agendamento_mensal (
  data_carga DATE NOT NULL,
  idfato_agendamento_mensal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  aux_tempo_idaux_tempo INT NULL,
  quantidade INT NULL,
  aux_clinica_idaux_clinica INT NULL,
  aux_medico_idaux_medico INT NULL,
  aux_procedimento_idaux_procedimento INT NULL,
  aux_status_idaux_status INT NULL,
  
  CONSTRAINT fk_fato_agendamento_mensal_aux_tempo
    FOREIGN KEY (aux_tempo_idaux_tempo)
    REFERENCES STG.aux_tempo (idaux_tempo),
	
  CONSTRAINT fk_fato_agendamento_mensal_aux_clinica
    FOREIGN KEY (aux_clinica_idaux_clinica)
    REFERENCES STG.aux_clinica (idaux_clinica),
	
  CONSTRAINT fk_fato_agendamento_mensal_aux_medico
    FOREIGN KEY (aux_medico_idaux_medico)
    REFERENCES STG.aux_medico (idaux_medico),
	
  CONSTRAINT fk_fato_agendamento_mensal_aux_procedimento
    FOREIGN KEY (aux_procedimento_idaux_procedimento)
    REFERENCES STG.aux_procedimento (idaux_procedimento),
	
  CONSTRAINT fk_fato_agendamento_mensal_aux_status
    FOREIGN KEY (aux_status_idaux_status)
    REFERENCES STG.aux_status (idaux_status) )
	
	
-------------- TABELAS VIOLACOES

	
CREATE TABLE STG.violacao_fato_agendamento (
  data_carga DATE NOT NULL,
  idfato_agendamento INT NULL,
  quantidade INT NULL,
  id_status INT NULL,
  id_medico INT NULL,
  id_clinica INT NULL,
  id_procedimento INT NULL,
  id_tempo INT NULL,
  mensagem VARCHAR(45) NULL,
  dt_auditoria DATE NULL,
  atualizado CHAR NULL )


CREATE TABLE STG.violacao_aux_procedimento (
  data_carga DATE NOT NULL,
  idaux_procedimento INT NULL,
  id_procedimento INT NULL,
  nome VARCHAR(45) NULL,
  valor NUMERIC(10,2) NULL,
  mensagem VARCHAR(45) NULL,
  dt_auditoria DATE NULL,
  atualizado CHAR NULL )


CREATE TABLE STG.violacao_aux_medico (
  data_carga DATE NOT NULL,
  idaux_medico INT NULL,
  id_medico INT NULL,
  nome VARCHAR(45) NULL,
  crm VARCHAR(45) NULL,
  especialidade VARCHAR(45) NULL,
  mensagem VARCHAR(45) NULL )


CREATE TABLE STG.violacao_aux_clinica (
  data_carga DATE NOT NULL,
  idaux_clinica INT NULL,
  id_clinica INT NULL,
  razao_social VARCHAR(45) NULL,
  cnpj VARCHAR(45) NULL,
  mensagem VARCHAR(45) NULL )


CREATE TABLE STG.violacao_aux_status (
  data_carga DATE NOT NULL,
  nome CHAR(2) NULL,
  mensagem VARCHAR(45) NULL )


CREATE TABLE STG.violacao_aux_tempo (
  data_carga DATE NOT NULL,
  data DATE NULL,
  mensagem VARCHAR(45) NULL )

    
CREATE TABLE STG.violacao_fato_agendamento_mensal (
  data_carga DATE NOT NULL,
  idfato_agendamento_mensal INT NULL,
  quantidade INT NULL,
  id_status INT NULL,
  id_procedimento INT NULL,
  id_medico INT NULL,
  id_clinica INT NULL,
  id_tempo INT NULL,
  mensagem VARCHAR(45) NULL )

  
  