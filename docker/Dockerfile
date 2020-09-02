# escape=`

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1.0

ENV ASPNETCORE_URLS=http://+:80

EXPOSE 80

WORKDIR interview
COPY interview .
ENTRYPOINT ["dotnet", "interview.dll"]
LABEL `
    name="interview" `
    version="1.0.0" `
    description="Dockerfile example for interview" `
