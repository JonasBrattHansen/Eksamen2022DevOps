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
