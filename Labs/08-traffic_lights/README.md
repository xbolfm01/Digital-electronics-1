# Priebeh simulácie  :

### Obrázok 1 : 
Ak signál count dopočíta do svojej maximálnej hodnoty (SEC 1 => 0001 a SEC5 => 1001), tak automaticky prejde do ďalšieho stavu.
Clock enable signál ma frekvenciu 2Hz, to znamená, že za 1 sekundu urobí 2 periódy. To môžeme vidieť na simulácii, pri SEC1(1 sekunda) má clock enable signál 2 periódy a pri SEC5 (5 sekúnd) tým pádom 10 periód
![Simulácia-1](https://user-images.githubusercontent.com/60688750/77897992-b961ea80-727a-11ea-82cd-1196cd380c3e.png)


### Obrázok 2 - Reset : 

Vidíme, že keď signál count dopočítal pri stave EWred2_NSred2, čo je ako posledný stav, do maximálnej hodnoty 0001 (SEC 1), tak sa cyklus znova opakuje a začína sa od stavu EWred_NSgreen, ktorý je ako prvý.  
![Simulácia-2-Reset](https://user-images.githubusercontent.com/60688750/77897998-bb2bae00-727a-11ea-9b79-03da256fd108.png)


### FSM Diagram : 
![Diagram](https://user-images.githubusercontent.com/60688750/77802736-ce245f80-707b-11ea-964a-78e7dba91827.jpg)


### Top_level_schematic : 

![Top_schematic](https://user-images.githubusercontent.com/60688750/77802732-ccf33280-707b-11ea-9ca0-f2f42fdadb2b.jpg)
