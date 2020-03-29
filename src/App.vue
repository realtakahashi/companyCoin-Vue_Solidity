<template>
  <div id="app">
    <!-- <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld msg="Welcome to Your Vue.js App"/>-->
    <h1>My Ether Balance is ...</h1>
    <h2>
      <font color="red">{{ethBalance}}</font>◆ or
      <font color="blue">{{weiBalance}}</font>wei
    </h2>
    <br />
    <h1>My FTT Coin Balance is ...</h1>
    <h2>
      <font color="green">{{fttBalance}}</font>FTT
    </h2>
    <br />
    <br />
    <br />
    <br />
    <h1>Get FTT Coins</h1>
    <input v-model="sendValue" />ether Send,
    <button @click="getCoins">Get Coins</button>
    <br />
    <br />
    <h1>FTT Coins Contract Address is....</h1>
    <h1>"{{vContractAddress}}"</h1>
  </div>
</template>

<script>
//import HelloWorld from './components/HelloWorld.vue'
import Web3 from "web3";

var gCoinbase = null;
var gWeb3 = null;
var gContract = null;

const contractAddress = "0xe1002706Fc342005CE8BE215D1247376ef61b759";
const wallectAddress = "0xE825fb97BeD5e85AE708B9b2A7A1b7967334B7a6";

// ERC20 トークンの残高を取得するための最小限のABI
var minABI = [
  {
    constant: false,
    inputs: [
      {
        name: "_spender",
        type: "address"
      },
      {
        name: "_value",
        type: "uint256"
      }
    ],
    name: "approve",
    outputs: [
      {
        name: "",
        type: "bool"
      }
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  },
  {
    constant: false,
    inputs: [
      {
        name: "_spender",
        type: "address"
      },
      {
        name: "_subtractedValue",
        type: "uint256"
      }
    ],
    name: "decreaseApproval",
    outputs: [
      {
        name: "",
        type: "bool"
      }
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  },
  {
    constant: false,
    inputs: [],
    name: "getCoin",
    outputs: [],
    payable: true,
    stateMutability: "payable",
    type: "function"
  },
  {
    constant: false,
    inputs: [
      {
        name: "_spender",
        type: "address"
      },
      {
        name: "_addedValue",
        type: "uint256"
      }
    ],
    name: "increaseApproval",
    outputs: [
      {
        name: "",
        type: "bool"
      }
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  },
  {
    constant: false,
    inputs: [
      {
        name: "_to",
        type: "address"
      },
      {
        name: "_value",
        type: "uint256"
      }
    ],
    name: "transfer",
    outputs: [
      {
        name: "",
        type: "bool"
      }
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  },
  {
    constant: false,
    inputs: [
      {
        name: "_from",
        type: "address"
      },
      {
        name: "_to",
        type: "address"
      },
      {
        name: "_value",
        type: "uint256"
      }
    ],
    name: "transferFrom",
    outputs: [
      {
        name: "",
        type: "bool"
      }
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  },
  {
    inputs: [
      {
        name: "_initialSupply",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "nonpayable",
    type: "constructor"
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "owner",
        type: "address"
      },
      {
        indexed: true,
        name: "spender",
        type: "address"
      },
      {
        indexed: false,
        name: "value",
        type: "uint256"
      }
    ],
    name: "Approval",
    type: "event"
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        name: "from",
        type: "address"
      },
      {
        indexed: true,
        name: "to",
        type: "address"
      },
      {
        indexed: false,
        name: "value",
        type: "uint256"
      }
    ],
    name: "Transfer",
    type: "event"
  },
  {
    constant: true,
    inputs: [
      {
        name: "_owner",
        type: "address"
      },
      {
        name: "_spender",
        type: "address"
      }
    ],
    name: "allowance",
    outputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [
      {
        name: "_owner",
        type: "address"
      }
    ],
    name: "balanceOf",
    outputs: [
      {
        name: "balance",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "decimals",
    outputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "getHello",
    outputs: [
      {
        name: "",
        type: "string"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "getRemainingCoin",
    outputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "getTokenBalanceOf",
    outputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "getTokenBalanceOf2",
    outputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "name",
    outputs: [
      {
        name: "",
        type: "string"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "remaingCoin",
    outputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "symbol",
    outputs: [
      {
        name: "",
        type: "string"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [
      {
        name: "",
        type: "address"
      }
    ],
    name: "tokenBalances",
    outputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: true,
    inputs: [],
    name: "totalSupply",
    outputs: [
      {
        name: "",
        type: "uint256"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  }
];

export default {
  name: "App",
  data: () => ({
    weiBalance: "",
    ethBalance: "",
    sendValue: "",
    fttBalance: "",
    vContractAddress: contractAddress
  }),
  created() {
    window.ethereum.enable();
    //const web3 = new Web3(window.web3.currentProvider);
    let self = this;
    if (window.web3) {
      gWeb3 = new Web3(window.web3.currentProvider);
      gWeb3.eth.getAccounts().then(function(accounts) {
        gCoinbase = accounts[0];
        console.log("accounts is " + accounts[0]);
        console.log("gCoinbase is " + gCoinbase);
        gWeb3.eth.getBalance(gCoinbase).then(function(tmpBalance) {
          console.log("tmpBlance: " + tmpBalance);
          self.weiBalance = tmpBalance;
          self.ethBalance = Web3.utils.fromWei(tmpBalance, "ether");
        });
        gContract = new gWeb3.eth.Contract(minABI, contractAddress);
        gContract.methods
          .balanceOf(wallectAddress)
          .call()
          .then(function(tBalance) {
            self.fttBalance = tBalance;
            console.log("tokenBalance: " + tBalance);
          });
      });
    }
  },
  methods: {
    getCoins() {
      let self = this;
      // コントラクトの呼び出し
      gContract.methods
        .getCoin()
        .send({
          from: gCoinbase,
          value: Web3.utils.toWei(this.sendValue, "ether")
        })
        .on("receipt", function() {
          console.log("success");
          //this.getTokenBalance(); //★関数を呼んでも動かない。Why? Promiseだから？
          //仕方ないのでまんまコピーする。。。。
          //FTT残高更新
          gContract.methods
            .balanceOf(wallectAddress)
            .call()
            .then(function(tBalance) {
              self.fttBalance = tBalance;
              console.log("tokenBalance: " + tBalance);
            });
          //Ether残高更新
          gWeb3.eth.getBalance(gCoinbase).then(function(tmpBalance) {
            console.log("tmpBlance: " + tmpBalance);
            self.weiBalance = tmpBalance;
            self.ethBalance = Web3.utils.fromWei(tmpBalance, "ether");
          });
        })
        .on("error", function() {
          console.log("error");
        });
    },
    getTokenBalance: function() {
      console.log("★getTokenBalance");
      // const contract = new gWeb3.eth.Contract(minABI, tokenAddress);
      // contract.methods.getTokenBalanceOf().call().then(console.log);  // ×：正しい値が取れず、常にゼロ
      // contract.methods.getHello().call().then(console.log);           // 〇：正しく動く
      // contract.methods.getRemainingCoin().call().then(console.log);   // 〇：正しく動ごく
      //gContract.methods.getTokenBalanceOf2().call().then(console.log); // ×：正しい値が取れず常にゼロ
      gContract.methods
        .balanceOf(wallectAddress)
        .call()
        .then(function(tBalance) {
          self.fttBalance = tBalance;
          console.log("tokenBalance: " + tBalance);
        });
    }
  },
  components: {
    //    HelloWorld
  }
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
