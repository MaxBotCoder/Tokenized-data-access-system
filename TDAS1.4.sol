//SPDX-License-Identifier: GPL-3.0+
pragma solidity 0.8.0;

contract Erc721Retrofit { //Adds functionality to erc721
    
}

contract AccessToken { //Similar to erc20 except used for access varification

    //Grants admin privaledges.
    mapping(address => bool) private AdminPrivaledges;

    //Debugging.
    uint public InteractionNumber;

    //Contract of origin.
    address private contractOfOrigin;

    //User linked to write.
    address public userMessager;

    //Additional user info.
    mapping(address => uint) public Allowance;
    mapping(address => uint) private TokensPurchasedByUser;

    //Personal ownership info.
    struct OwnerInfo {
        bool isBuyer;
        uint TokensBought;
        uint timeTillAccessExpires; //Time untiil data access will expire.
    }

    //General token related info.
    string public tokenName;
    string public tokenSymbol; 
    uint public tokensSold;

    //Token tier related features.
    mapping(uint => uint) public tokenTierToPrice;
    mapping(uint => uint) public TierToTime; //Must be configured before deployment.
    mapping(address => OwnerInfo) public tokenOwnership; //Address represents owner in question, first uint represents token tier, second uint represents quantity, bool represents if user is owner.

    //Modifiers.
    modifier requireAdmin() { //Admin privaledges needed.
        require(AdminPrivaledges[msg.sender] == true, "You are not an admin.");
        _;
    }

    modifier requireExternalContract() {
        require(msg.sender == contractOfOrigin, "Invalid permissions.");
        _;
    }

    modifier CanBuy (uint _Tier) { //Determines if someone is capable of buying a token.
        require(Allowance[userMessager] == tokenTierToPrice[_Tier], "Not enough funds to complete transaction.");
        _;
    }

    //functions pre-constructor.
    function tokenEditor(uint _Tier, uint _UintPrice) payable public requireAdmin() requireExternalContract() {
        tokenTierToPrice[_Tier] = _UintPrice;
    }

    //Prepairs contract.
    constructor (string memory _TokenName, string memory _TokenSymbol, uint _Tier1Price, uint _Tier2Price, uint _Tier3Price, address _UserAdmin) { 
        tokenName = _TokenName;
        tokenSymbol = _TokenSymbol;
        contractOfOrigin = msg.sender;

        AdminPrivaledges[msg.sender] = true;
        AdminPrivaledges[_UserAdmin] = true;
        tokenEditor( 1, _Tier1Price);
        tokenEditor( 2, _Tier2Price);
        tokenEditor( 3, _Tier3Price);

        //Must be configured before deployment.
        TierToTime[ 1] = 32 days; //1 month
        TierToTime[ 2] = 196 days; //6 months
        TierToTime[ 3] = 365 days; //1 year

    }

    function trueMessager (address _UserMessager) public requireExternalContract() { //Makes sure tokens are allocated to user or user contract not control pannel contract.
        require(msg.sender == contractOfOrigin, "Cannot alter outside of buyer interface contract.");
        userMessager = payable(address(_UserMessager));
    }

    fallback () external payable {
        require(msg.value == tokenTierToPrice[1] || msg.value == tokenTierToPrice[2] || msg.value == tokenTierToPrice[3], "Not enough funds to complete transaction.");
        if(msg.value == tokenTierToPrice[1] || msg.value == tokenTierToPrice[2] || msg.value == tokenTierToPrice[3]) {
        Allowance[userMessager] += msg.value;
        }
    }

    function mintTokenForOwner (uint _Tier) public CanBuy(_Tier) requireExternalContract() {
        require(_Tier == 1 || _Tier == 2 || _Tier == 3, "Invalid options.");
        uint DisposableAllowance = Allowance[userMessager];
        Allowance[userMessager] = 0;

        if(DisposableAllowance == tokenTierToPrice[_Tier] && tokenOwnership[userMessager].isBuyer == false) {
            tokensSold++;
            TokensPurchasedByUser[userMessager]++;
            tokenOwnership[userMessager] = OwnerInfo(true, TokensPurchasedByUser[userMessager], TierToTime[_Tier] + block.timestamp);
        } else if (DisposableAllowance == tokenTierToPrice[_Tier] && tokenOwnership[userMessager].isBuyer == true) {
            tokensSold++;
            TokensPurchasedByUser[userMessager]++;
            tokenOwnership[userMessager].TokensBought = TokensPurchasedByUser[userMessager];
            tokenOwnership[userMessager].timeTillAccessExpires += TierToTime[_Tier];
        }
        
        InteractionNumber++;
    }

}

contract BuyerInterface { //Buyers interface.

    AccessToken public TokenContract;
    address private TokenAddress;

    constructor (string memory _TokenName, string memory _TokenSymbol, uint _Tier1Price, uint _Tier2Price, uint _Tier3Price) {

        TokenContract = new AccessToken(_TokenName, _TokenSymbol, _Tier1Price, _Tier2Price, _Tier3Price, msg.sender);
        TokenAddress = payable(address(TokenContract));

    }

       function buyToken(uint _Tier) public payable {

        TokenContract.trueMessager(msg.sender);
        (TokenAddress).call {value: msg.value}("");
        TokenContract.mintTokenForOwner(_Tier);

    }

}
