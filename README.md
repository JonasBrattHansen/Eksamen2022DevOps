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
Ettersom GitHub Actions aldri fant testene måtte dette legges til slik at den fikk tilgang til de. Da feilet testene:
```
 - name: Test
   run: mvn --batch-mode -Dmaven.test.failure.ignore=false test
``` 
Også endret jeg testen fra expected 100 til 0 og da passa testen. Også i GitHub Actions! 