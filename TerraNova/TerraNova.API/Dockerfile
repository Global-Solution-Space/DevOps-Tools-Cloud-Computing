FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
USER $APP_UID
WORKDIR /terranova-app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY TerraNova.API/TerraNova.API.csproj TerraNova.API/
COPY TerraNova.Application/TerraNova.Application.csproj TerraNova.Application/
COPY TerraNova.Domain/TerraNova.Domain.csproj TerraNova.Domain/
COPY TerraNova.Infrastructure/TerraNova.Infrastructure.csproj TerraNova.Infrastructure/
COPY TerraNova.Integration/TerraNova.Integration.csproj TerraNova.Integration/
RUN dotnet restore TerraNova.API/TerraNova.API.csproj
COPY . .
RUN dotnet publish TerraNova.API/TerraNova.API.csproj -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
COPY --from=build --chown=$APP_UID:$APP_UID /app/publish .
ENTRYPOINT ["dotnet", "TerraNova.API.dll"]