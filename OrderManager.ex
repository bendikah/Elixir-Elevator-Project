defmodule  OrderManager do
  #Calculates the cost of an order
  def calculateCost(order, currentFloor, currentDirection, orderList, currentState) do
    cond do
      #TODO: research cond do
      #If the elevator is in an error state, we will not accept any new orders.
      currentState == "Error" ->
        cost = 10000

      #Cab orders automatically receive a cost of 0 since they have to be serviced by
      #self.
      order.type == "cab" ->
        cost = 0

      currentState == "Idle" ->
        cost = abs(order.floor - currentFloor)/4

      #Hall calls are where the real logic begins.
      order.type == "hall" ->
        cond do
          #If the elevator is moving up, and the order is in the same direction as the current direction, there are two scenarios
          currentDirection == "up" && order.direction == currentDirection ->
            cond do
              #If the order is on a floor lower than the maximum floor number currently in orderList, we give the order a "low" cost.
              #TODO: maximum() and minimum() are not implementet yet for orderList.
              order.floor < orderList.maximum() ->
                cost = abs(order.floor - currentFloor)/2
              #If the order is on a floor higher than the maximum floor number currently in orderList, we give the order a higher cost.
              order.floor > orderList.maximum() ->
                cost = abs(order.floor - currentFloor)
            end

          #If the elevator is moving up, and the direction of the order is not up, we give the order a "high" cost.
          currentDirection == "up" && order.direction != currentDirection ->
            cost = 2*abs(order.floor - currentFloor)

          #If the elevator is moving down, and the order is in the current direction, there are two scenarios
          currentDirection == "down" && order.direction == currentDirection ->
            cond do
              #If the order is on a floor higher than the minimum floor number currently in orderList, we give the order a "low" cost.
              order.floor > orderList.minimum() ->
                cost = abs(order.floor - currentFloor)/2

              #If the order is on a floor lower than the minimum floor number currently in orderList, we give the order a higher cost.
              order.floor < orderList.minimum() ->
                cost = abs(order.floor - currentFloor)
            end

          #If the elevator is moving down, and the direction of the order is not down, we give the order a "high" cost.
          currentDirection == "down" && order.direction != currentDirection ->
            cost = 2*abs(order.floor - currentFloor)
        end
    end

    #Returns the calculated cost.
    cost

  end
end
