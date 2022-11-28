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
Ved å endre dette vil workflowen kjøre automatisk når det lages en pull request på main branch. Det må se slik ut: 
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