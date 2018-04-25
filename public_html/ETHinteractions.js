
function loadScript(url, callback)
{
    // Adding the script tag to the head as suggested before
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = url;

    // Then bind the event to the callback function.
    // There are several events for cross browser compatibility.
    script.onreadystatechange = callback;
    script.onload = callback;

    // Fire the loading
    head.appendChild(script);
}

var ETHinters = function()
{
  console.log("ethinters loaded");
}



loadScript("web3.js", ETHinters);
loadScript("ethjs.js", ETHinters);

function loadContract(contractAddres, contactABI)
{
  var ignoreMetamask = false;



  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (ignoreMetamask == false && typeof web3 !== 'undefined')
	{
    // Use Mist/MetaMask's provider
		 console.log('Web3 Detected! ' + web3.currentProvider.constructor.name);
    web3js = new Web3(web3.currentProvider);
		ethlocal = new Eth(web3js.currentProvider);
  }
	else
	{
    console.log('No web3? You should consider trying MetaMask!')
		console.log("would have been nice to use ", web3.currentProvider);
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    web3js = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
		ethlocal = new Eth(web3js.currentProvider);
  }

  var ethlocal = new Eth(web3js.currentProvider);
	var contractAbi = ethlocal.contract(contractABI);
	var contract = contractAbi.at(contractAddress);
  return contract;
	//myContract.getPoints.call().then(function(a){a,console.log(a[0].words,a,a.toString(),+a.toString(),'Bananas');});



}
