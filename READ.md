Snake code from here:
* https://www.youtube.com/watch?v=xGmXxpIj6vs&t=307s
* https://pastebin.com/Z3zhb7cY

General Steps:
1. run Ganache for a local ethereum blockchain
2. Run remix, and connect it to your local ethereum blockchain from Ganache
3. load up PointStore.sol into Remix and compile it on your local blockchain.

Specific Steps:
1. run Ganache
2. run remix and in Run->Environment choose "Web3 Provider"
3l. choose the http://localhost:7545 (which is the ganache endpoint in my case)
4. in Remix select Compile->"start to compile
5. in remix press Run->Create
6. From remix, copy the test hash (blockchain) into the game code contractAddress
7. from remix copy the account hash into the game code Accountaddress
8. start a http server from the root of the game folder "http-server -p 1337 ."
"
