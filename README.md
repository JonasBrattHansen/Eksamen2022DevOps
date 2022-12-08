# DEL 1 - DevOps-prinsipper
(Oppgavene blir besvart i samme tekst) 
* Utfordringene med dagens systemutviklingsprosess er nesten alt. De gjør alt halvferdig og får egentlig aldri noen god flyt i det de gjør. De velger å hoppe over operasjoner som gjør andre operasjoner lettere senere. De har dårlig flyt ettersom de aldri får github actions til å fungere. Feedback har de også generelt ingenting av - annet enn 1 lokal test. De her ingen overvåkning, metrics, logger, responstider, grafer eller lignende - det er veldig viktig for en bedrift å få innsikt og tilbakemeldigner på hvordan og (om i det hele tatt) ting funker i systemene deres.   
Kontinuelig forbedring er her vi kommer inn ;) fikse problemene slik at de kan holde seg "friske" - det beste er å lage systemer med et godt immunforsvar slik at de kan forsvare seg selv uten for mye menneskelig hjelp. Et godt immunforsvar lærer av sine feil og klarer da og utvikle seg til å ikke bli "syk" av den samme feilen igjen - dette er veldig relevant for IT bedrifter.
Slik de driver med utvikling nå blir systemene bare dårligere og dårligere og ikke bedre og bedre (slik det burde være)
Deres vanlige respons på mange feil er å release mindre hyppig og dermed heller publisere mye kode samtidig og dermed hvis det er feil i koden vil denne gjemme seg godt inni alt dette. Ved å ha en hyppigere release med mindre funksjonalitet per release gjør det at hele prosessen kan gå smoothere og mer smertefritt - det vil dukke opp feil ja men disse vil være nokså enkle å fikse ettersom det kun er èn liten funksjonalitet.
Med kontoinuelig integrasjon, levereanse og deployment gir det bedriften mye mer kontroll over koden de releaser og gjør det mulig å release oftere og fortere. 
Som det også står så overleverer teamet koden til en drift avdeling som da får ansvaret av å drifte koden - dette kan skape mange problemer ettersom de hele tiden vil få tildelt ny kode - og denne koden er ikke alltid bra og enkel å forstå. Det vil ta mye tid å sette seg inn i all koden - og for alt jeg vet gir de ikke feedback tilbake til utviklingsteamet på hva som kunne vært gjoprt bedre og lignende. 
Å ha ett team som er avsvarlig for både utvikling og drift skaper en bedre flyt, en bedre kontinuelig utvikling og de kommer til å få mye bedre kontroll på sin kode og hva den gjør + hva som er dårlig/bra. Siden de allerede har laget koden er det lite å sette seg inn i sånn sett men de får da litt ekstra arbeid ved å drifte den men det vil nok ikke være et problem - dette vil også gi bedriften mindre teknisk gjeld. 
Hyppig realse av kode kan også gi problemer. Det kan komme mange forskjellige småproblemer ut i systemet, det krever mer tid og resursser. Men igjen alt dette kan fikses eller forbedres på en eller annen måte. Med god feedback - feks fra github actions - kan det være med på å redusere alle disse småfeilene og dermed gjøre at det ikke blir så ille alikevel.  


# DEL 2 - CI
## Oppgave 1
I ci.yml filen er det lagt til: 
```
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
        run: |
          aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 244530008913.dkr.ecr.eu-west-1.amazonaws.com
          rev=$(git rev-parse --short HEAD)
          docker build . -t ${{ github.sha }}
          docker tag ${{ github.sha }}  244530008913.dkr.ecr.eu-west-1.amazonaws.com/1029:$rev
           docker tag ${{ github.sha }} 244530008913.dkr.ecr.eu-west-1.amazonaws.com/1029:latest
          docker push 244530008913.dkr.ecr.eu-west-1.amazonaws.com/1029:$rev
          docker push 244530008913.dkr.ecr.eu-west-1.amazonaws.com/1029:latest
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
Terraform apply gjør basically det den blir fortalt til å gjøre - og du prøver jo å lage en ny bucket med samme navn - og som sagt går ikke dette.
Men etter utallinge push requests og googling i flere dager fant jeg en fix i workflowen som løste problemet. 

## Oppgave 2
* if: github.ref == 'refs/heads/main' && github.event_name == 'pull' og if: github.ref == 'refs/heads/main' && github.event_name == 'push' må legges til i workflow filen på plan og apply :)

## Alarmer og oppgave 3 (Dashboard)
Alarmen kjører også som den skal. Den går over 5 på grafen også tar det ca 15-20 sekunder før alarmen går. Om dette er meningen eller ikke vet jeg ikke. 
Det står også "Pending confirmation" selvom jeg har bekreftet det i topics.. jeg får mail når alarmen utløses. 
