def stock_picker(prices)
  pick = (0...prices.length-1)
    .map { |i| [prices[i], prices[i+1..].max, i] } # cost, selling price, index
    .sort { |t1, t2| t1[0]-t1[1] <=> t2[0]-t2[1] } # sort by profit
    .first # most profitable pick after sorting

  [pick[2], prices[pick[2]+1..].index(pick[1])+pick[2]+1] # calculate indexes
end

p stock_picker([17,3,6,9,15,8,6,1,10])
