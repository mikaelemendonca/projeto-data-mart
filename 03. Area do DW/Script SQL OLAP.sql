
-------------- TABELA DO DW

CREATE SCHEMA DW

CREATE TABLE DW.dim_tempo (
  iddim_tempo INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
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


CREATE TABLE DW.dim_procedimento (
  iddim_procedimento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  id_procedimento INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  valor FLOAT NOT NULL,
  dt_inicio DATETIME NOT NULL,
  dt_fim DATETIME NULL,
  fl_corrente VARCHAR(3) NOT NULL CHECK (FL_CORRENTE IN ('SIM','NAO')))


CREATE TABLE DW.dim_clinica (
  iddim_clinica INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  id_clinica INT NOT NULL,
  razao_social VARCHAR(45) NOT NULL,
  cnpj VARCHAR(45) NOT NULL )


CREATE TABLE DW.dim_medico (
  iddim_medico INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  id_medico INT NOT NULL,
  nome VARCHAR(45) NOT NULL,
  crm VARCHAR(45) NOT NULL,
  especialidade VARCHAR(45) NOT NULL )


CREATE TABLE DW.dim_status (
  iddim_status INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  id_status INT NOT NULL,
  nome CHAR(2) NOT NULL )


CREATE TABLE DW.fato_agendamento (
  idfato_agendamento INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  id_proc_agendado INT NOT NULL,
  dim_tempo_iddim_tempo INT NOT NULL,
  dim_procedimento_iddim_procedimento INT NOT NULL,
  dim_clinica_iddim_clinica INT NOT NULL,
  dim_medico_iddim_medico INT NOT NULL,
  dim_status_iddim_status INT NOT NULL,
  quantidade INT NOT NULL,
  dt_inicio DATETIME NOT NULL,
  dt_fim DATETIME NULL,
  fl_corrente VARCHAR(3) NOT NULL CHECK (FL_CORRENTE IN ('SIM','NAO')),
  
  CONSTRAINT fk_fato_agendamento_dim_tempo
    FOREIGN KEY (dim_tempo_iddim_tempo)
    REFERENCES DW.dim_tempo (iddim_tempo),

  CONSTRAINT fk_fato_agendamento_dim_procedimento
    FOREIGN KEY (dim_procedimento_iddim_procedimento)
    REFERENCES DW.dim_procedimento (iddim_procedimento),

  CONSTRAINT fk_fato_agendamento_dim_clinica
    FOREIGN KEY (dim_clinica_iddim_clinica)
    REFERENCES DW.dim_clinica (iddim_clinica),

  CONSTRAINT fk_fato_agendamento_dim_medico
    FOREIGN KEY (dim_medico_iddim_medico)
    REFERENCES DW.dim_medico (iddim_medico),

  CONSTRAINT fk_fato_agendamento_dim_status
    FOREIGN KEY (dim_status_iddim_status)
    REFERENCES DW.dim_status (iddim_status) )


CREATE TABLE DW.fato_agendamento_mensal (
  idfato_agendamento_mensal INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  dim_tempo_iddim_tempo INT NOT NULL,
  dim_clinica_iddim_clinica INT NOT NULL,
  dim_medico_iddim_medico INT NOT NULL,
  dim_procedimento_iddim_procedimento INT NOT NULL,
  dim_status_iddim_status INT NOT NULL,
  quantidade INT NOT NULL,

  CONSTRAINT fk_fato_agendamento_mensal_dim_tempo
    FOREIGN KEY (dim_tempo_iddim_tempo)
    REFERENCES DW.dim_tempo (iddim_tempo),
	
  CONSTRAINT fk_fato_agendamento_mensal_dim_clinica
    FOREIGN KEY (dim_clinica_iddim_clinica)
    REFERENCES DW.dim_clinica (iddim_clinica),
	
  CONSTRAINT fk_fato_agendamento_mensal_dim_medico
    FOREIGN KEY (dim_medico_iddim_medico)
    REFERENCES DW.dim_medico (iddim_medico),
	
  CONSTRAINT fk_fato_agendamento_mensal_dim_procedimento
    FOREIGN KEY (dim_procedimento_iddim_procedimento)
    REFERENCES DW.dim_procedimento (iddim_procedimento),
	
  CONSTRAINT fk_fato_agendamento_mensal_dim_status
    FOREIGN KEY (dim_status_iddim_status)
    REFERENCES DW.dim_status (iddim_status) )
	
	