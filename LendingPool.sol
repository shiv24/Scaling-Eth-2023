pragma solidity >=0.8.0 <0.9.0;








contract LendingPool {
    address private owner;




    uint fundsInvested;




    constructor() {
        owner = msg.sender; 
    }


    uint requestId;




    struct LoanRequest{
        string creditScore;
        string homeAddress;
        uint downPayment;
        uint requestedMortgage;
        uint months;
        uint expiry;
        uint remaining;
    }


    struct lender{
        address lender;
        uint amount;
    }




    //only one address can have a request at a time.
    mapping(address => uint) public borrowRequest;
    mapping(uint => LoanRequest) public requestReference;


    //mapping of a requestId to a 0 or 1. If a listing is expired, it's value will be 1.
    mapping(uint => bool) requestExpired;


    //mapping the requestId to the list of contributors
    mapping(uint => lender[]) contributionMap;




    function initLoan(string memory creditScore, string memory homeAddress,
        uint downPayment,
        uint requestedMortgage,
        uint months,
        uint expiry,
        uint remaining) public pure returns (LoanRequest memory) {
                LoanRequest memory loanReq = LoanRequest(creditScore, homeAddress, downPayment, requestedMortgage, months, expiry, remaining);
                return loanReq;
        }






  // AddMarketItem(): This function adds a loan request to the marketplace.

  function addMarketItem(LoanRequest memory lr, uint expiry) public {
      uint reqId = requestId;
      lr.expiry = block.timestamp + expiry;
      requestId = requestId + 1;
      borrowRequest[msg.sender] = reqId;
      requestReference[reqId] = lr;
  }


  // ContributeFunds: This function allows a Lender to contribute funds to the borrower

    function contributeFunds(uint reqId) public payable {

        require(msg.value < 1000);

        (bool success,) = msg.sender.call{value: 123}("");


    }



    function balanceOf() external view returns(uint) {
        return address(this).balance;
    }






   // Need to figure out the payment logic.




}
