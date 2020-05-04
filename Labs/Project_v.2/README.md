# Projekt 
## Zadanie projektu :
PWM stmievač s nastaviteľnou dobou načasovania s rotačným enkoderom KY-040 s tlačítkom. Po uplynutí zadanej doby sa výstup zo 100% plynulo stlmí na nulu.

==========================================================================================================

### Tento projekt je oproti projektu, ktorý tu bol nahraný vo štvrtok, opravený a funguje tu PWM. Projekt, ktorý bol nahraný vo štvrtok, je na Githube stále nezmenený pod názvom "Project". Tento projekt je len oprava PWM. Opravu PWM si môžeme všimnúť v bode 4 (Simulácie) a v bode 5 (Záver). Nižšie je zdôvodnené prečo PWM nefugovala a ako prebiehal proces jej opravenia. Opravu projektu sme nahrali na Github z dôvodu, že sme sa s predchádzajúcim výsledkom neuspokojili a stále sme hľadali kde by mohla byť chyba. Keď sme chybu našli a odstránili, tak sme chceli aby tu bolo aj toto nové, už správne, riešenie.

==========================================================================================================

Problém s PWM bol spôsobený len malou chybou v kóde v súbore top.vhd. Konkrétne bola chyba, že v binary_cnt2 bola do vstupu srst_n_i privedená '1', lenže to zaručovalo to, že tento čítač stále bežal a stále sledoval stav referenčnej úrovne a porovnával ju s komparačnou, čiže PWM nefungovala. Po kontrolách kódu som do vstupu srst_n_i priradil signál btn, práve preto, aby tento časovač bežal len pri zmene signálu btn 0 -> 1 (z aktívnej úrovne do neaktívnej), to znamená, že keď tlačidlo pustíme, tým pádom začne časovanie od nastavenej hodnoty a začne aj generovanie referenčného signálu a jeho sledovanie binary_cnt2. Po tejto oprave už PWM na led fungovalo úplne bez problému, viď foto simulácie. 
### Foto opravy v kóde : 
![Correction in code](https://user-images.githubusercontent.com/60688750/80930218-5cde7780-8db2-11ea-99b9-69ab7306b3fe.jpg)

----------------------------------------------------------------------------------------------------------------------------------------

### 1. Popis kódu :
Comparator :
Slúži nám na porovnávanie úrovní pri postupnom zhášaní LED. Vstupy do comparatoru sú refIn a setIn. Vstupom setIn nastavujeme úroveň. Tam kde je setIn vyššia ako refIn, má výstupná premenná hodnotu 0 (LED svieti), v opačnom prípade má hodnotu 1 (LED nesvieti). Viď obrázok PWM.

#### Counter_down :
Slúži nám pre odpočítavanie od nastavenej hodnoty. Ak je reset aktívny, tak sa s počítadlom nič nedeje. Naopak ak je reset neaktívny a zároveň je aktívny povolovací vstup en_i, tak sa výstup (cnt_o) dekrementuje o -1.

#### binary_cnt :
Tento čítač odštartujeme tým, keď signál countingStart bude mať hodnotu 1, to znamená, že sa začne odpočet nastavenej hodnoty.

#### binary_cnt_2 :
Tento čítač beží stále. Je taktovaný hodinovým signálom. Slúži na čítanie hodnoty refIn hodnoty referenčného signálu, číta od vrchu dole – viď obrázok PWM. Výstupom tohto čítaču je teda hodnota signálu refIn.-----

#### binary_cnt_3 :
Určuje hodnotu komparačnej úrovne, to znamená, že na základe jeho výstupu je dané ako dlho LED bude svietiť. Tento čítač sa spustí ak signál countinDone bude mať hodnotu 1, čiže keď sa dopočíta do nuly z nastavenej hodnoty. Čítač sa dekrementuje každú ms. Ak dopočíta do svojej maximálnej hodnoty , to znamená, že komparačná úroveň je úplne na najnižšom bode (setIn = x“000“) a LED je vypnutá. Po tomto procese sa na signál countingDone nastaví hodnota 0 a čítač sa vypne.

#### top :
Komponent top sa skladá z jednotlivých častí, sú to comparator, driver_7seg, clock_enable, binary_cnt a counter_down. Teraz si popíšeme kód, ktorý obsahuje súbor top.vhd. Ako prvé by som spomenul nastavovanie času na displej, resp. enkodér. Enkodér nám slúži na nastavovanie času, po ktorom sa má LED zhasnúť. Toto v kóde riešime tým spôsobom, že snímame pozície enkódera (enc_value_A, enc_value_B) a hradlom XOR. To znamená, že ak sa pozícia enkodéra nezmení, tak tak nám do hradla XOR vstupujú dve 0, čiže 0 XOR 0 = 0, to znamená, že sa pozícia nezmenila a na displeji ostáva ten istý čas. Naopak ak enkóderom pohneme, tak sa zmení jeho pozícia a tým pádom nám do hradla XOR vstupuje 1 XOR 0 = 1, takže sme vyhodnotili, že pozícia sa zmenila. V závislosti na tom, do akej strany pootočíme sa hodnota času na displeji buď zvyšuje alebo znižuje, resp. podľa toho sa počítadlo (counter_disp) bude buď inkrementovať alebo dekrementovať. Ak bude na displeji čas 0000 a potočili by sme enkóderom do strany, kde sa nastavený čas na displeji za normálnych okolností dekrementuje, tak tomto prípade sa s časom nebude diať nič, nakoľko stav 0000 je najnižší možný. Týmto spôsobom sme si nastavili čas na displej. Teraz sa nebude diať nič až pokiaľ nestlačíme tlačidlo. Keď tlačidlo stlačíme, tak sa s nábežnou hranou hodín inkrementuje debouncerCounter. Tu overujeme či bolo tlačidlo naozaj stlačené alebo nastal výskyt parazitného impulzu. Doska je taktovaná frekvenciou 8MHz a my chceme použiť frekvenciu 200Hz, to znamená, že ak debounceCounter dopočíta do 40 000 (svojho maxima), tak sa vynuluje a paralelne stým sa do signálu btnFlagu nastaví 1, čo znamená, že sa tlačidlo bolo naozaj stlačené a môže sa začať odpočet nastaveného času. Teraz nastáva odpočet času. Pri nábežnej hrane clk_i a pri signále btnFlag = 1, sa nastaví signál countingStart do 1 (signalizuje začatie odpočítavania) a signál ledHelp do 0 (LED začne svietiť). Ak sa hodnota čítača, (afterCounter) bude rovnať čítaču, ktorý odpočítava nastavenú hodnotu (counter_disp), znamená to, že sa odpočet skončil a signál countingDone sa nastaví do 1. AfterCounter je taktovaný na sekundy, to znamená, že ho môžeme porovnať s čítačom, ktorý počíta nastavený čas. Hodnota komparačnej úrovne (setIn) má hexadecimálnu hodnotu x“000“ (je úplne na 0) čo má za následok, že sa nastaví signál countingStart do 0 (nakoľko neprebieha odpočet), countingDone do 0 (neprebieha žiadny odpočet) a signál ledHelp sa nastaví na 1 (čo znamená, že LED nesvieti).

### 2. Schéma zapojenia Topu :
![top_scheme](https://user-images.githubusercontent.com/60688750/80929398-00785980-8dac-11ea-915a-16ccb5a35388.jpg)

### 3. Princíp PWM aj s názvami signálov nášho projektu :
![PWM](https://user-images.githubusercontent.com/60688750/80929425-2aca1700-8dac-11ea-9450-1ef900c9ec0b.jpg)

### 4.Simulácia :
##### [Obrázok simulácie - 1] 
Môžeme vidieť, že signál seconds, nám ukazuje hodnotu, ktorú sme si "natočili" (nastavili) rotačným enkodérom, v našom prípade to je hodnota 8 (1000). Ďalej môžeme sledovať to, že tlačítko sme stlačili, čiže prešlo do aktívneho stavu, do 0. Stlačenie tlačidla vyvolalo spustenie časovača, odpočtu od nastavenej hodnoty (countinStart). Taktiež to má vplyv na pomocné signály ledHelp 2 a ledHelp. Stlačenie tlačidla takisto vyvolalo zaktivizovanie signálu btnFlag, ktorý je aktívny len počas aktívnej úrovne btn.  Keď už tlačidlo pustíme a znova prejde do neaktívneho stavu (do 1), tak vidíme, že to má vplyv na signál LED a to konkrétne taký, že môžeme pozorovať začiatok PWM procesu. 

![Sim 1](https://user-images.githubusercontent.com/60688750/80929459-8694a000-8dac-11ea-9449-cdccbc88ca80.png)


##### [Obrázok simulácie - 2] 
Na tomto obrázku simulácie môžeme vidieť zmeny komparačnej úrovne, ktorú popisuje signál setIn a spoločne s týmto môžeme sledovať začiatok procesu PWM čo znázorňuje signál led. LED najskôr svieti na 100% a potom sa postupne zháša. Tento jav vidíme v simulácii tak, že signál led je väčšinu času v hodnote 0 a pulzy do hodnoty 1 sú len veľmi úzke. 
![Sim 2](https://user-images.githubusercontent.com/60688750/80929470-9318f880-8dac-11ea-9a60-44d80a41a805.png)

##### [Obrázok simulácie - 3] 
Pozorujeme už len postupné zhášanie LED. LED sa čím ďalej tým viac ustaluje neaktívnej úrovni (1), čo má za následok, že LEDka sa viac a viac stmavuje.

![Sim 3](https://user-images.githubusercontent.com/60688750/80929650-0a9b5780-8dae-11ea-844e-59eb6e5405dd.png)

##### [Obrázok simulácie - 4] 
LED je už takmer úplne ustálená v hodnote 1, čiže už takmer vôbec nesvieti.

![Sim 4](https://user-images.githubusercontent.com/60688750/80929664-2999e980-8dae-11ea-82fc-4ebaf909cdd7.png)

##### [Obrázok simulácie - 5] 
Vidíme, že komparačná úroveň dosiahla "0000000000", čo znamená, že je úplne na minime (viď bod 3 Princíp PWM). Tým pádom musí byť LED už úplne zhasnutá, to môžeme vidieť na signále led, že teraz je už úplne ustálená v hodnote 1.

![setIn](https://user-images.githubusercontent.com/60688750/80929699-767dc000-8dae-11ea-8d82-216a2915c508.png)

### 5. Záver :
Po stlačení tlačidla, sa spustí časovač na odpočet od nastavenej hodnoty. Následne na to, sa spustí proces PWM a LEDka sa začne zhášať, čo môžeme vidieť na simulácii.

### 6. Video :
Na videu simulujeme natočenie enkóderom tlačidlami, ktorými nastavíme čas.                                                                
https://www.youtube.com/watch?v=I9aNll9A6zU

### 7. Zdroje :
Predchádzajúce cvičenia od pána doc.Frýzu                                                                                                 
https://www.digikey.com/eewiki/pages/viewpage.action?pageId=62259228                                                                                                                     
https://en.wikipedia.org/wiki/Pulse-width_modulation                                                                                           
https://howtomechatronics.com/tutorials/arduino/rotary-encoder-works-use-arduino/
