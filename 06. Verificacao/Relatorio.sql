------- INDICADOR: AGENDAMENTOS POR MÉDICO CLINICA
SELECT Clinica.razao_social as 'Clinica', Medico.nome as 'Médico', SUM(Fato.quantidade) as 'Quantidade' FROM DW.fato_agendamento Fato 
		INNER JOIN DW.dim_clinica Clinica ON Fato.dim_clinica_iddim_clinica = Clinica.iddim_clinica
		INNER JOIN DW.dim_medico Medico   ON Fato.dim_medico_iddim_medico   = Medico.iddim_medico
    GROUP BY Medico.nome, Clinica.razao_social
	ORDER BY Clinica.razao_social	

------ INDICADOR: TIPOS DE PROCEDIMENTOS MAIS AGENDADOS POR MÉDICO/CLINICA
SELECT Clinica.razao_social as Clinica, Procedimento.nome as 'Procedimento', Medico.nome as 'Médico', SUM(Fato.quantidade) as 'Quantidade' FROM DW.fato_agendamento Fato
		INNER JOIN DW.dim_clinica Clinica           ON Fato.dim_clinica_iddim_clinica           = Clinica.iddim_clinica
		INNER JOIN DW.dim_medico Medico             ON Fato.dim_medico_iddim_medico             = Medico.iddim_medico
		INNER JOIN DW.dim_procedimento Procedimento ON Fato.dim_procedimento_iddim_procedimento = Procedimento.iddim_procedimento
	GROUP BY Clinica.razao_social,Procedimento.nome,Medico.nome 
	
------ INDICADOR: STATUS AGENDAMENTO POR MÉDICO/CLINICA
SELECT Clinica.razao_social as 'Clinica', St.nome as 'Status', Medico.nome as 'Médico', SUM(Fato.quantidade) as 'Quantidade' FROM DW.fato_agendamento Fato
		INNER JOIN DW.dim_clinica Clinica ON Fato.dim_clinica_iddim_clinica  = Clinica.iddim_clinica
		INNER JOIN DW.dim_medico Medico   ON Fato.dim_medico_iddim_medico    = Medico.iddim_medico
		INNER JOIN DW.dim_status St       ON Fato.dim_status_iddim_status    = St.iddim_status
	GROUP BY St.nome, Medico.nome, Clinica.razao_social
	ORDER BY Clinica.razao_social

------ INDICADOR: AGENDAMENTOS POR DIA POR MÉDICO/CLINICA
SELECT Clinica.razao_social as 'Clinica', Dia.data as 'Data', Medico.nome as 'Médico', SUM(Fato.quantidade) as 'Quantidade' FROM DW.fato_agendamento Fato
		INNER JOIN DW.dim_clinica Clinica ON Fato.dim_clinica_iddim_clinica  = Clinica.iddim_clinica
		INNER JOIN DW.dim_medico Medico   ON Fato.dim_medico_iddim_medico    = Medico.iddim_medico
		INNER JOIN DW.dim_tempo Dia       ON Fato.dim_tempo_iddim_tempo      = Dia.iddim_tempo
	GROUP BY Dia.data, Medico.nome, Clinica.razao_social
	ORDER BY Clinica.razao_social

------ INDICADOR: DIA COM MAIOR NUMERO DE ATENDIMENTOS POR MÉDICO/CLINICA
SELECT Clinica.razao_social as 'Clinica', Medico.nome as 'Médico',Dia.data as 'Quantidade' ,SUM(Fato.quantidade) as 'Quantidade' FROM DW.fato_agendamento Fato
		INNER JOIN DW.dim_clinica Clinica ON Fato.dim_clinica_iddim_clinica  = Clinica.iddim_clinica
		INNER JOIN DW.dim_medico Medico   ON Fato.dim_medico_iddim_medico    = Medico.iddim_medico
		INNER JOIN DW.dim_tempo Dia       ON Fato.dim_tempo_iddim_tempo      = Dia.iddim_tempo
	GROUP BY Dia.data, Medico.nome, Clinica.razao_social
	ORDER BY Clinica.razao_social,SUM(Fato.quantidade) DESC
	
------ INDICADOR: DIA COM MENOR NUMERO DE ATENDIMENTOS POR MÉDICO/CLINICA
SELECT Clinica.razao_social as 'Clinica', Medico.nome as 'Médico',Dia.data as 'Data' ,SUM(Fato.quantidade) as 'Quantidade' FROM DW.fato_agendamento Fato
		INNER JOIN DW.dim_clinica Clinica ON Fato.dim_clinica_iddim_clinica  = Clinica.iddim_clinica
		INNER JOIN DW.dim_medico Medico   ON Fato.dim_medico_iddim_medico    = Medico.iddim_medico
		INNER JOIN DW.dim_tempo Dia       ON Fato.dim_tempo_iddim_tempo      = Dia.iddim_tempo
	GROUP BY Dia.data, Medico.nome, Clinica.razao_social 
	ORDER BY Clinica.razao_social,SUM(Fato.quantidade) ASC 
	
------ INDICADOR: FATURAMENTO POR MÉDICO/CLINICA POR DIA
SELECT Clinica.razao_social as 'Clinica', Medico.nome as 'Médico',Dia.data as 'Data',SUM(Procedimento.valor) as 'Faturamento'  FROM DW.fato_agendamento Fato
		INNER JOIN DW.dim_clinica       Clinica         ON Fato.dim_clinica_iddim_clinica			= Clinica.iddim_clinica
		INNER JOIN DW.dim_medico		Medico          ON Fato.dim_medico_iddim_medico				= Medico.iddim_medico
		INNER JOIN DW.dim_tempo			Dia		        ON Fato.dim_tempo_iddim_tempo				= Dia.iddim_tempo
		INNER JOIN DW.dim_procedimento  Procedimento    ON Fato.dim_procedimento_iddim_procedimento = Procedimento.iddim_procedimento
	GROUP BY Dia.data, Medico.nome, Clinica.razao_social 
	ORDER BY Clinica.razao_social,SUM(Procedimento.valor) DESC



------ INDICADOR: FATURAMENTO POR MÉDICO/CLINICA POR MÊS
SELECT Clinica.razao_social as 'Clinica', Medico.nome as 'Médico',Dia.mes as 'Mês',SUM(Procedimento.valor) as 'Faturamento'  FROM DW.fato_agendamento Fato
		INNER JOIN DW.dim_clinica       Clinica         ON Fato.dim_clinica_iddim_clinica			= Clinica.iddim_clinica
		INNER JOIN DW.dim_medico		Medico          ON Fato.dim_medico_iddim_medico				= Medico.iddim_medico
		INNER JOIN DW.dim_tempo			Dia		        ON Fato.dim_tempo_iddim_tempo				= Dia.iddim_tempo
		INNER JOIN DW.dim_procedimento  Procedimento    ON Fato.dim_procedimento_iddim_procedimento = Procedimento.iddim_procedimento
	GROUP BY Dia.mes, Medico.nome, Clinica.razao_social 
	ORDER BY Clinica.razao_social,SUM(Procedimento.valor) DESC

------ INDICADOR: FATURAMENTO TOTAL DA CLINICA POR MÊS
SELECT Clinica.razao_social as 'Clinica',SUM(Procedimento.valor) as 'Faturamento'  FROM DW.fato_agendamento Fato
		INNER JOIN DW.dim_clinica       Clinica         ON Fato.dim_clinica_iddim_clinica			= Clinica.iddim_clinica	
		INNER JOIN DW.dim_procedimento  Procedimento    ON Fato.dim_procedimento_iddim_procedimento = Procedimento.iddim_procedimento
	GROUP BY Clinica.razao_social 
	ORDER BY Clinica.razao_social,SUM(Procedimento.valor) 

