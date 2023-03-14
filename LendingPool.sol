pragma solidity >=0.8.0 <0.9.0;

contract LendingPool {
    address private owner;
    uint fundsInvested;

    constructor() {
        owner = msg.sender; 
    }

    uint requestCount;

    struct LoanRequest{
        string creditScore;
        string homeAddress;
        uint downPayment;
        uint requestedAmount;
        uint months;
        uint expiry;
        uint remaining;
    }

    struct Lender{
        address lender;
        uint amount;
    }

    //only one address can have a request at a time.
    mapping(address => uint) public borrowRequest;
    mapping(uint => LoanRequest) public requestReference;

    //mapping of a requestId to a 0 or 1. If a listing is expired, it's value will be 1.
    mapping(uint => bool) public requestExpired;

    //mapping the requestId to the list of contributors
    mapping(uint => Lender[]) public contributionMap;

    function initLoan(string memory creditScore, string memory homeAddress,
        uint downPayment,
        uint requestedAmount,
        uint months,
        uint expiry,
        uint remaining) public pure returns (LoanRequest memory) {
                LoanRequest memory loanReq = LoanRequest(creditScore, homeAddress, downPayment, requestedAmount, months, expiry, remaining);
                return loanReq;
        }

  // AddMarketItem(): This function adds a loan request to the marketplace.

  function addMarketItem(LoanRequest memory lr, uint expiry) public {
      uint reqId = requestCount;
      lr.expiry = block.timestamp + expiry;
      requestCount += 1;
      borrowRequest[msg.sender] = reqId;
      requestReference[reqId] = lr;
  }


  // ContributeFunds: This function allows a Lender to contribute funds to the borrower

    function contributeFunds(uint reqId, uint amount) public payable {

        require(msg.value < 1000);
        require(msg.value % 100 == 0);

        require(msg.value == amount);


        LoanRequest storage req = requestReference[reqId];

        uint total = msg.value + req.remaining;
        uint refund = 0;
        uint remain = req.requestedAmount - total;

        if (total > req.requestedAmount) {
            refund = total - req.requestedAmount;
            remain = 0;
        }

        req.requestedAmount = remain;

        Lender memory l = Lender(msg.sender, msg.value);

        contributionMap[reqId].push(l);

        if (refund > 0){
            (bool success,) = msg.sender.call{value: refund}("");
        }

    }


    function balanceOf() external view returns(uint) {
        return address(this).balance;
    }

   //obtainLoan:The borrower can Withdraw funds for a loan once fuly crowdfunded

   //submitPayment: The borrower will submit a payment which will be distributed across lenders

}
