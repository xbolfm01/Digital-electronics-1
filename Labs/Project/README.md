# Projekt 
### Zadanie projektu:  
PWM stmievač s nastaviteľnou dobou načasovania s rotačným enkoderom KY-040 s tlačítkom. Po uplynutí zadanej doby sa výstup zo 100% plynulo stlmí na nulu.

### 1. Popis kódu : 
#### Comparator : 
Slúži nám na porovnávanie úrovní pri postupnom zhášaní LED. Vstupy do comparatoru sú refIn a setIn. Vstupom setIn nastavujeme úroveň. Tam kde je setIn vyššia ako refIn, má výstupná premenná hodnotu 0 (LED svieti), v opačnom prípade má hodnotu 1 (LED nesvieti). Viď obrázok PWM. 

#### Counter_down : 
Slúži nám pre odpočítavanie od nastavenej hodnoty. Ak je reset aktívny, tak sa s počítadlom nič nedeje. Naopak ak je reset neaktívny a zároveň je aktívny povolovací vstup en_i, tak sa výstup (cnt_o) dekrementuje o -1. 

#### binary_cnt : 
Tento čítač odštartujeme tým, keď signál countingStart bude mať hodnotu 1, to znamená, že sa začne odpočet nastavenej hodnoty. 

#### binary_cnt_2 :
Tento čítač beží stále. Je taktovaný hodinovým signálom. Slúži na čítanie hodnoty refIn hodnoty referenčného signálu, číta od vrchu dole – viď obrázok PWM. Výstupom tohto čítaču je teda hodnota signálu refIn.

#### binary_cnt_3 :
Určuje hodnotu komparačnej úrovne, to znamená, že na základe jeho výstupu je dané ako dlho LED bude svietiť. Tento čítač sa spustí ak signál countinDone bude mať hodnotu 1, čiže keď sa dopočíta do nuly z nastavenej hodnoty. Čítač sa dekrementuje každú ms. Ak dopočíta do svojej maximálnej hodnoty , to znamená, že komparačná úroveň je úplne na najnižšom bode (setIn = x“000“) a LED je vypnutá. Po tomto procese sa na signál countingDone nastaví hodnota 0 a čítač sa vypne.

#### top :
Komponent top sa skladá z jednotlivých častí, sú to comparator, driver_7seg, clock_enable, binary_cnt a counter_down. Teraz si popíšeme kód, ktorý obsahuje súbor top.vhd. Ako prvé by som spomenul nastavovanie času na displej, resp. enkodér. Enkodér nám slúži na nastavovanie času, po ktorom sa má LED zhasnúť. Toto v kóde riešime tým spôsobom, že snímame pozície enkódera (enc_value_A, enc_value_B) a hradlom XOR. To znamená, že ak sa pozícia enkodéra nezmení, tak tak nám do hradla XOR vstupujú dve 0, čiže 0 XOR 0 = 0, to znamená, že sa pozícia nezmenila a na displeji ostáva ten istý čas. Naopak ak enkóderom pohneme, tak sa zmení jeho pozícia a tým pádom nám do hradla XOR vstupuje 1 XOR 0 = 1, takže sme vyhodnotili, že pozícia sa zmenila. V závislosti na tom, do akej strany pootočíme sa hodnota času na displeji buď zvyšuje alebo znižuje, resp. podľa toho sa počítadlo (counter_disp) bude buď inkrementovať alebo dekrementovať. Ak bude na displeji čas 0000 a potočili by sme enkóderom do strany, kde sa nastavený čas na displeji za normálnych okolností dekrementuje, tak tomto prípade sa s časom nebude diať nič, nakoľko stav 0000 je najnižší možný. Týmto spôsobom sme si nastavili čas na displej. Teraz sa nebude diať nič až pokiaľ nestlačíme tlačidlo. Keď tlačidlo stlačíme, tak sa s nábežnou hranou hodín inkrementuje debouncerCounter.  Tu overujeme či bolo tlačidlo naozaj stlačené alebo nastal výskyt parazitného impulzu. Doska je taktovaná frekvenciou 8MHz a my chceme použiť frekvenciu 200Hz, to znamená, že ak debounceCounter dopočíta do 40 000 (svojho maxima), tak sa vynuluje a paralelne stým sa do signálu btnFlagu nastaví 1, čo znamená, že sa tlačidlo bolo naozaj stlačené a môže sa začať odpočet nastaveného času. Teraz nastáva odpočet času.  Pri nábežnej hrane clk_i a pri signále btnFlag = 1, sa nastaví signál countingStart do 1 (signalizuje začatie odpočítavania) a signál ledHelp do 0 (LED začne svietiť). Ak sa hodnota čítača, (afterCounter) bude rovnať čítaču, ktorý odpočítava nastavenú hodnotu (counter_disp), znamená to, že sa odpočet skončil a signál countingDone sa nastaví do 1. AfterCounter je taktovaný na sekundy, to znamená, že ho môžeme porovnať s čítačom, ktorý počíta nastavený čas. Hodnota komparačnej úrovne (setIn) má hexadecimálnu hodnotu x“000“ (je úplne na 0) čo má za následok, že sa nastaví signál countingStart do 0 (nakoľko neprebieha odpočet), countingDone do 0 (neprebieha žiadny odpočet) a signál ledHelp sa nastaví na 1 (čo znamená, že LED nesvieti).

### 2. Schéma zapojenia Topu :
![top_scheme](https://user-images.githubusercontent.com/60688750/80761938-d456a180-8b3b-11ea-83ed-be1ee10a47d0.jpg)

### 3. Princíp PWM so signálmi na našom projekte : 
Na obrázku vidíme princíp PWM. Červená je komparačná úroveň, šedý je referenčný signál a zelený je výstup signálu ledHelp2. Môžeme z obrázku vidieť, že čím menšia je úroveň (červená), tým dlhšie ostáva výstup ledHelp2 (zelený) v 1. V reále to znamená, že LED bude sa bude stále viac a viac stmavovať až úplne zhasne. LED v 0 = svieti , LED v 1 = nesvieti. 
![PWM](https://user-images.githubusercontent.com/60688750/80762310-9312c180-8b3c-11ea-9a6a-fab0cfe2ac7c.jpg)

### 4. Simulácia : 
Na simulácii môžeme vidieť, že pri stlačení tlačidla (btn išlo do 0) išiel do 0 aj signál reprezentujúci led (led išiel do 0). Paralelne s týmto sa odštartoval časovač (signál countinStart išiel do 1) a vypol sa časovač countingDone (countingDone išiel do 0). Takisto môžeme vidieť peaky v signále btnFlag, čo znamená, že tlačidlo bolo stlačené. 
![Simulation - Pressed button](https://user-images.githubusercontent.com/60688750/80762603-23e99d00-8b3d-11ea-8bdb-b3331e90ce83.png)


### 5. Záver :
Dokázali sme, že pri stlačení tlačidla, sa LED automaticky rozsvieti. Čo sa nám už nepodarilo pri simulácii dokázať je to, že po čase sa LED automaticky začne vypínať. Paradoxom je, že keď sme projekt nahrali do dosky tak tam to fungovalo, viď video. 

### 6. Video :
Na videu simulujeme natočenie enkóderom tlačidlami, ktorými nastavíme čas.
https://www.youtube.com/watch?v=I9aNll9A6zU

### 7. Zdroje :
Predchádzajúce cvičenia od pána doc.Frýzu

https://www.digikey.com/eewiki/pages/viewpage.action?pageId=62259228
https://en.wikipedia.org/wiki/Pulse-width_modulation
https://howtomechatronics.com/tutorials/arduino/rotary-encoder-works-use-arduino/
