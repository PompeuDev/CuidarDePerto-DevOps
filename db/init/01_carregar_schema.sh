#!/bin/bash
# Executado automaticamente pela imagem gvenzl/oracle-free na PRIMEIRA inicialização do banco
# (volume vazio). Roda o script SQL do projeto conectado como o usuário da aplicação, para que
# as tabelas T_CDP_* fiquem no mesmo schema que a API usa.
echo "CUIDAR DE PERTO: criando tabelas, carga inicial e procedures no schema ${APP_USER}..."

sqlplus -s "${APP_USER}/${APP_USER_PASSWORD}@//localhost/FREEPDB1" <<SQL
WHENEVER SQLERROR CONTINUE
SET SERVEROUTPUT ON
@/opt/cuidar-sql/GlobalSolutionDB.sql
EXIT
SQL

echo "CUIDAR DE PERTO: schema carregado."
