# syntax=docker/dockerfile:1

# ---------- Estágio 1: build (SDK .NET 8) ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia só o .csproj primeiro: o 'restore' fica em cache enquanto as dependências não mudarem
COPY CuidarDePerto.Api.csproj ./
RUN dotnet restore

# Agora o restante do código e a publicação
COPY . ./
RUN dotnet publish CuidarDePerto.Api.csproj -c Release -o /app/publish --no-restore

# ---------- Estágio 2: runtime (somente o ASP.NET, sem SDK) ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# Usuário NÃO-root para executar a aplicação
RUN groupadd --system --gid 10001 cuidar \
 && useradd  --system --uid 10001 --gid cuidar --no-create-home --shell /usr/sbin/nologin cuidar

COPY --from=build --chown=cuidar:cuidar /app/publish ./

# Porta > 1024 (não exige root). O compose publica 80 (host) -> 8080 (container)
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

USER cuidar
ENTRYPOINT ["dotnet", "CuidarDePerto.Api.dll"]
