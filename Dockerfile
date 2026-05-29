# IPNote.ir — Web API + Angular SPA (Release publish)
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs npm \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /src
COPY . .
RUN dotnet restore Ntk.Note.IP.sln \
    && dotnet publish src/Web/Web.csproj -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production
EXPOSE 8080
COPY --from=build /app/publish .
HEALTHCHECK --interval=30s --timeout=5s --start-period=90s --retries=3 \
  CMD curl -sf http://localhost:8080/health || exit 1
ENTRYPOINT ["dotnet", "Ntk.Note.IP.Web.dll"]
