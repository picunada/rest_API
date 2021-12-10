#FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
#WORKDIR /app
#EXPOSE 80
#EXPOSE 443
#
#FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
#WORKDIR /src
#COPY ["Catalog.csproj", "./"]
#RUN dotnet restore "../Catalog.csproj"
#COPY . .
#WORKDIR "/src/Catalog"
#RUN dotnet build "../Catalog.csproj" -c Release -o /app/build
#
#FROM build AS publish
#RUN dotnet publish "../Catalog.csproj" -c Release -o /app/publish
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "Catalog.dll"]

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
# Copy csproj and restore as distinct layers
COPY *.sln .
COPY *.csproj .

RUN mkdir /tmp/build/
COPY . /tmp/build
RUN find /tmp/build -name *.csproj

RUN dotnet restore Catalog.csproj --verbosity detailed
# Copy everything else and build
COPY . .
WORKDIR /src/Catalog
RUN dotnet build "../Catalog.csproj" -c Release -o /app --no-restore

FROM build AS publish
WORKDIR /src/Catalog
RUN dotnet publish "../Catalog.csproj" -c Release -o /app


FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Catalog.dll"]