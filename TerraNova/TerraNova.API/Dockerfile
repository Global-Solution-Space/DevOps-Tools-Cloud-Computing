#  TerraNova.API, arquivo Dockerfile
#  Localização: src/TerraNova.API/Dockerfile
#  Build context: raiz do repositório (docker compose usa context: .)


#  Runtime base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base

# Usuário não-privilegiado fornecido pela imagem .NET
# $APP_UID = UID 1654 (user "app") — não é root
USER $APP_UID

# Diretório de trabalho personalizado dentro do container
WORKDIR /terranova-app

# Porta exposta da API
EXPOSE 8080

#  Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release

WORKDIR /src

# Copiar apenas os .csproj primeiro → melhor cache de layers
COPY src/TerraNova.API/TerraNova.API.csproj                      TerraNova.API/
COPY src/TerraNova.Application/TerraNova.Application.csproj      TerraNova.Application/
COPY src/TerraNova.Domain/TerraNova.Domain.csproj                TerraNova.Domain/
COPY src/TerraNova.Infrastructure/TerraNova.Infrastructure.csproj TerraNova.Infrastructure/
COPY src/TerraNova.Integration/TerraNova.Integration.csproj      TerraNova.Integration/

# Restaurar dependências (usa cache se .csproj não mudou)
RUN dotnet restore TerraNova.API/TerraNova.API.csproj

# Copiar o restante do código-fonte
COPY src/ .

WORKDIR /src/TerraNova.API
RUN dotnet build TerraNova.API.csproj \
    -c $BUILD_CONFIGURATION \
    -o /app/build


#  Publish
FROM build AS publish
ARG BUILD_CONFIGURATION=Release

RUN dotnet publish TerraNova.API.csproj \
    -c $BUILD_CONFIGURATION \
    -o /app/publish \
    /p:UseAppHost=false

#  Imagem Final
FROM base AS final

WORKDIR /terranova-app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "TerraNova.API.dll"]