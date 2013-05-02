module BidsystemExceptions
  class InsufficientFundsError < StandardError
  end

  class InvalidAmountError < StandardError
  end

  class AuctionClosedError < StandardError
  end

  class BidRaceConditionError < StandardError
  end
end
