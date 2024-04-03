# Flutter Assignment | Essentially AI

> Building a trading application involves a lot of things like the frontend platform, interaction with stock exchanges for placing orders, interaction with banks for fund requirements, user protection features so their trades don't give them wild losses etc...


## Task

> Your task is to build the frontend of an MVP version of this trading app on Flutter which should include the following feature.

#### Watchlist screen:
1. This is one of the core components on any trading platform.
2. We'll give you a json with 30 stocks with their tokens as keys and values containing a bunch of other fields which would be completely suffient for this assignment and you would not require any additional data.
3. Display these stocks on the watchlist. It should contain the symbol and the LTP (Last traded price), the process of getting LTP is given below.
4. Join the given websocket to display the LTP of the stock on the watchlist. The websocket would be active most of the times, in case there's a downtime, it would be back up in 2 hours. The websocket has a rate limit of 1 message per second, just to be safe take it to be 1.5 sec per message.
   1. Here's how you can subscribe and unsubscribe to an instrument's LTP:
   ```
    {
        "Task": "subscribe",
        "Mode": "ltp",
        "Tokens": [3, 7, 13, 17, 19, 22, 25]
    }
    {
        "Task": "unsubscribe"
        "Mode": "ltp",
        "Tokens": [3, 7]
    }
   ```
   2. Display the data received from the websocket on the watchlist corresponding to every stock.
6. Implement a delete from watchlist functionality upon left swipe of the specific stock.
   1. You're supposed to manage the unsubscriptions from websocket as well.

## Parameters for evaluation
1. Core functionality
2. Efficiency
3. Exhaustiveness of edge cases
4. Scalability
5. UI/UX Sense
6. Code structure and readability


## Bonus Points
1. Any additional features on the given base MVP, given that it doesn't require any additional data inputs or APIs.
