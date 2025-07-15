# Analisi e comparazione dei sistemi DeFI che usano AMM e Liquidity Pools
Cocco Mattia 65336
Lepuri Tomas 65358
Blockchain and Smart Contracts 2025

## Istruzioni codice
Nella repository sono presenti 2 file solidity: il file ```creazioneToken.sol```, che contiene i contratti che definiscono i due token utilizzati nello scenario e ```automatedMarketMaker.sol```, che contiene il contratto relativo all'AMM che gestisce il pool tra i due token, con le funzioni descritte nella relazione e in seguito.

I passaggi necessari per utilizzare l'AMM sono comunque spiegati anche nell'ultimo capitolo della relazione in pdf.


### TokenA e TokenB

I contratti contenuti in ```creazioneToken.sol``` sono 2 e sono identici a parte per quanto riguarda il nome del contratto, il nome del token e il simbolo. 

È necessario compilare il file e eseguire la deploy dei contratti su una rete per poter usufruire delle loro funzioni.
Nel nostro esempio i contratti TokenA e TokenB sono stati caricati sulla testnet Sepolia e sono accessibili rispettivamente agli address ```0x7844cd2bc2f99b574c7153f94ab1803b490a0512``` e ```0x5113d1e5849f0689987a8ec7bd18467caa2740a7```.
Si ricorda tuttavia che il modifier ```onlyowner``` consente solo al proprietario di eseguire la mint in questo esempio.

Per ottenere i token è necessario eseguire la ```mint``` fornendo l'indirizzo in cui si vogliono ricevere e la quantità di token, ricordando che un singolo TokenA o TokenB si scrive ```1000000000000000000```, dato che il parametro ha 18 decimali.
Per verificare l'arrivo dei token è possibile chiamare la ```balanceOf``` sull'indirizzo a cui sono stati inviati i token.
Sono disponibili anche le altre funzioni ereditate da ERC20, tra cui i trasferimenti.

Per il corretto funzionamento dei test su AMM è **fondamentale** chiamare la funzione ```approve``` dall'indirizzo su cui si hanno i token che si vogliono utilizzare (indirizzi dei liquidity provider), specificando come parametri l'indirizzo del contratto dell'AMM e la quantità complessiva di token che gli permettiamo di gestire per conto nostro.
Questa operazione è necessaria sia per TokenA che per TokenB, altrimenti l'AMM non avrà i permessi necessari a gestire i nostri token. 


### Automated Market Maker

Nel file ```automatedMarketMaker.sol``` è presente un unico contratto. È sempre necessario eseguire la compilazione del file e il deploy del contratto, per poter utilizzare l'AMM.
Nel nostro esempio il contratto si trova sempre sulla testnet Sepolia, all'indirizzo ```0xc5110d8c44a6a6d7b74e53260eaecc83d6afcca7```.

È **importante** evitare di utilizzare quantità di token infinitesimali negli swap, come per esempio 1, 2, 3... quintillionesimi di token ("wei"), o, se lo si fa, bisogna aspettarsi che i conti sulla base della funzione di swap non tornino, dato che c'è alta probabilità di underflow.
Si ricorda che le funzioni prendono in input parametri con 18 decimali, quindi un TokenA per esempio si indica con ```1000000000000000000```.

Prima di poter chiamare le funzioni del contratto è necessario assicurarsi ancora una volta di avere chiamato la ```approve``` di TokenA e TokenB sull'indirizzo del contratto, altrimenti le transazioni non andranno a buon fine.

#### Mint
Per fornire liquidità al pool si può utilizzare la ```mint``` con le quantità dei due token come parametri, assicurandosi che nessuna quantità sia nulla, altrimenti verrà restituito l'errore di liquidità mintata insufficiente.

Una volta forniti TokenA e TokenB al pool, si ottengono shares del pool, dette anche LP token.

Si può verificare la liquidità totale del pool espressa in shares con ```totalLiquidity```, mentre è possibile conoscere le shares attribuite a un indirizzo, passandolo come parametro a ```liquidity```.
È anche possibile controllare la quantità di TokenA e TokenB presenti nel pool, chiamando rispettivamente ```reserveA``` e ```reserveB```.

#### Burn
Invece, per prelevare i TokenA e TokenB in cambio di shares in nostro possesso è necessario chiamare la ```burn``` con la quantità di shares da "bruciare" come parametro.
Si ricorda che la quantità di TokenA e TokenB restituiti in cambio di shares è proporzionale alle riserve attuali del pool.
Si ricorda che anche la quantità di shares è espressa con 18 decimali, quindi una share si scrive ```1000000000000000000```.

#### Swap
Per eseguire lo scambio di un token per l'altro si chiama la funzione ```swap``` specificando l'indirizzo del contratto del token che stiamo offrendo e la sua quantità sempre con 18 decimali.

Naturalmente questo contratto permette lo swap esclusivamente su TokenA e TokenB.

Si possono eseguire controlli abbastanza agevolmente controllando i bilanci di token e di liquidità dei nostri indirizzi e delle riserve del pool, prima e dopo l'esecuzione di queste operazioni.

Se si utilizza MetaMask, l'interfaccia di conferma delle transazioni dovrebbe anche indicare un'anteprima delle quantità di token che si riceveranno e/o si spenderanno.
MetaMask durante la ```approve``` mostra anche il cap dei token per cui stiamo dando il permesso all'AMM.







