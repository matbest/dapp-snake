# Mid Term Project

## _Goal:_ Determine if a 'Live' game can be hosted on IPFS and ethereum

**Live** has a very specific meaning in the games industry: it means that the game can be updated and iterated on without losings its user-base or address. Also, it can be tracked through analytics, and a loop created between measuring the behavior of users in a game, and modifying the game based on those results.

 **What this is not:**
 * An exercise in beautiful or even legible code.
 * An exercise in creating a good game: I live game can become good, but a static game will remain as it started.

### Questions to be answered:
1. Can a game be hosted on IPFS and also be modified without loosing the ipfs address?
1. Can a user of a game hosted on IPFS have confidence that the game is legitimate?
1. Can we track users of the game through IPFS?

### Results:
* **Game** https://gateway.ipfs.io/ipfs/QmfSsTbbv4g7hCkseLXCgp8mvmUCsE4nZbBv3qfBjLPqKp/start.html
* **Code** https://github.com/matbest/dapp-snake

1. Yes (sort-of, using redirects)
1. yes, (by making the game address hosted on ethereum where people can be confident in it)
1. Undetermined.

### Snake code from here:
* https://www.youtube.com/watch?v=xGmXxpIj6vs&t=307s
* https://pastebin.com/Z3zhb7cY

### General Steps:
1. install MetaMask
1. connect MetaMask to Ropsten
1. visit the IPFS address above.

### The Pattern
1. Static ipfs page retreives live game IPFS address from ethereum and send the user to it (using start.html residing on the above IPFS address)
2. Operations department can upload new games to IPFS and modify the contract containing the live game page ( using Operations.html )
3. Live game is played from IPFS without it needing to know about its static address. (snake.html)

![Pattern picture](IPFS%20ethereum%20pattern.png)

# Next Steps:
1. Clean and comment the code (dont bother to read it right now, it's mvp for functionality)
1. Determine better bounce method (iframes or whatnot)
1. Get some analytics into the the static and live game page.
1. Start to make an awesome game by updating it live while people are playing it.
