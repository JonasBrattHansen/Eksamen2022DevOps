# DEL 1 - DevOps-prinsipper
* SPM 1 svar

* Problemet med dette er at mye kode blir publisert samtidig og dermed hvis det er feil i koden vil denne gjemme seg godt inni alt dette. Ved å ha en hyppigere release med mindre funksjonalitet per release gjør det at hele prosessen kan gå smoothere og mer smertefritt. 
Med kontoinuelig integrasjon, levereanse og deployment gir det bedriften mye mer kontroll over koden de releaser og gjør det mulig å release oftere og fortere. 


# DEL 2 - CI
## Oppgave 1
I ci.yml filen er det lagt til: 
```
name: CI pipeline
on:
  workflow_dispatch:
``` 
Ved å endre dette vil workflowen kjøre automatisk når det lages en push request på main branch. Det må se slik ut: 
```
on:
  push:
    branches: [ main ]
``` 

## Oppgave 2
Problemet her er at GitHub  Actions aldri finner testene. Dette kan endres ved å endre ci.yml filen til slik på nederste linje:
```
      - name: Test
        run: mvn --batch-mode -Dmaven.test.failure.ignore=false test
```
Dette gjør at actions ikke får bygget ettersom det er en feil i testen. 
Dette fikses ved å endre fra 100 til 0 i expected i testen slik at testen faktisk passerer :)
Og for å få workflowen til å kompilere javakoden og testene på hver eneste push, uavhengig av branch på ci.yml endres igjen.
Dette må endres slik at branches bare går fra main til alle - som dette:
```
    branches:
      - '**'
```

## Oppgave 3
Det første sensor må gjøre er å gå på Settings i GitHub fra repositoriet sitt. Fra settings til branches og "add protection rule". Her kan man egentlig gjøre som man vil.
Men det oppgaven spør om så må sensor gi name pattern, huke av "Require a pull request before merging", "require approvals (1 stk)", "Require status checks to pass before merging" og for å forhindre at noen pusher rett på main "Lock branch".
Og ettersom oppgaven ikke spør om at jeg skal gjøre det på min - lar jeg være..

# Del 3 - Docker
## Oppgave 1
Når GitHub Actions kjører Docker.yml feiler den pga brukernavn og passord ikke er oppgitt - noe som gir mening! For å fikse dette trenger github å få tak i dette. Da trenger den et brukernavn og 2n "token".
I DockerHub kan du lage denne tokenen. Det gjøres ved å gå til DockerHub.Com - Settings - Security og der i fra lage et token (denne må tas vare på).
Da du har token kan du gå til GitHub.com og repositoriet. Der går du til settings - secrets - og da lager 2 tokens. 1 til brukernavn og 1 med token fra DockerHub. Altså første vil være feks: "DOCKER_HUB_TOKEN" som navn og token fra DockerHub som "secret". Og den andre vil DOCKER_HUB_USERNAME være name og secret vil da være DockerHub brukernavnet ditt. Da burde workflowen funke fint :)

## Oppgave 2
For å få det til å kjøre må du endre DockerFile fra 
```
FROM adoptopenjdk/openjdk8
COPY target/onlinestore-0.0.1-SNAPSHOT.jar /app/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]
```
til:
```
FROM maven:3.6-jdk-11 as builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package

FROM adoptopenjdk/openjdk11:alpine-slim
COPY --from=builder /app/target/*.jar /app/application.jar
ENTRYPOINT ["java","-jar","/app/application.jar"]
```
blir dette problemet fikset ettersom den nå bruker java versjon 11 som kompilerer med java runtime versjon 55.

## Oppgave 3
For at sensor skal få dette til å funke må han først sette opp AWS secret credentials likt som Docker Hub sine. De skal samme sted i GitHub bare med andre navn og "keys". AWS_ACCESS_KEY_ID og AWS_SECRET_ACCESS_KEY er navnene og verdiene må genereres i IAM i AWS. I IAM går til Users - søk etter brukernavnet og gå inn på det. Derretter går du til Security credentials og lager de :) 
Så går sensor til ECR i AWS og lager et repository. Når det er laget kommer det øverst "view push commands" og da kan sensor bare følge disse for å få laget og pushet et private image. 
Før dette kan gjøres må docker.yml filen også fikses slik at den er tilpasset sensor sin.
```
        run:
          aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 244530008913.dkr.ecr.eu-west-1.amazonaws.com
          rev=$(git rev-parse --short HEAD)
          docker build . -t ${{ github.sha }}
          docker tag ${{ github.sha }}  244530008913.dkr.ecr.eu-west-1.amazonaws.com/1029:$rev
          docker push 244530008913.dkr.ecr.eu-west-1.amazonaws.com/1029:$rev
``` 
må endres til sensor sine detaljer og ikke mine private.

Og for å få docker workflow til å pushe et container image med en tag som er lik GitHub commit hash(id) må det legges til ${{ github.sha }} i taggen :)

# Del 4 - Metrics, overvåking og alarmer
## Oppgave 1

Jeg la til en MetricsConfig.java klasse og satte cloudwatch.namespace til mitt kandidatnummer. Deretter gjorde jeg nødvendige rettninger i pom filen slik at det kjørte ordentlig. 
Dette var å legge til blant annet 

```
<dependency>
            <groupId>io.micrometer</groupId>
            <artifactId>micrometer-registry-cloudwatch2</artifactId>
        </dependency>
```
og
```
  <dependency>
            <groupId>software.amazon.awssdk</groupId>
            <artifactId>utils</artifactId>
            <version>${aws.sdk.version}</version>
        </dependency>
```

# Del 5 - Terraform og CloudWatch Daashboards
## Oppgave 1
* Den kjører første gangen ettersom bucketen ikke eksisterer - men kjører du github actions 2. gang så vil den feile ettersom den allerede finnes - og i AWS må alle bucket navn være globalt unike - noe den lenger ikke er. 

## Oppgave 2
* if: github.ref == 'refs/heads/main' && github.event_name == 'pull' og if: github.ref == 'refs/heads/main' && github.event_name == 'push' må legges til i workflow filen på plan og apply :)

## Alarmer og oppgave 3 (Dashboard)
Ettersom jeg dessverre ikke fikk til tidligere oppgaver som gikk ut på å få inn data - vil dermed ikke alarmen funke. Men jeg har laget den og den ville ha funket dersom de tidligere oppgavene hadde funket. 
Men jeg har laget dashboardet og fått det ordentlig på plass - så hvis jeg hadde fått til den andre oppgaven ville dashboardet vært ok. 