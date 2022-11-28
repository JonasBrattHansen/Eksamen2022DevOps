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