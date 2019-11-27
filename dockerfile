FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /app

# Copy projetct and restore
COPY *.sln .
COPY netcoredocker/*.csproj ./netcoredocker/
RUN dotnet restore

# Copy everything else and build
COPY netcoredocker/. ./netcoredocker/
WORKDIR /app/netcoredocker
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime
WORKDIR /app/
COPY --from=build-env /app/netcoredocker/out .
COPY docker-entrypoint.sh .
RUN chmod +x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]