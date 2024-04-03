# Flutter Assignment | Essentially AI

> Building a trading application involves a lot of things like the frontend platform, interaction with stock exchanges for placing orders, interaction with banks for fund requirements, user protection features so their trades don't give them wild losses etc...


## Task

> Your task is to build the frontend of an MVP version of this trading app on Flutter which should include the following feature.

#### Watchlist screen:
1. This is one of the core components on any trading platform.
2. We'll give you a json with 30 stocks with their tokens and a bunch of other fields which would be completely suffient for this assignment and you would not require any additional data.
3. This screen should have a searchbar and a list of the stocks which are added in the watchlist.
   1. Initially the list should be empty and be populated by the user using the searchbar.
   2. Once a stock is added in the watchist, the list item should contain the ticker of the stock and the LTP (Last Traded Price) and how to get the LTP is described below.
4. Create a function to implement the search functionality
   1. Make it closest to the real world scenario without using any external API (all the logic should be in your code).
   2. Think about cases like user entering wrong spelling, searching using industry, company, symbol etc...
   3. Upon clicking the search suggestion, the stock should be added in the watchlist.
5. Join the given websocket to display the LTP of the stock on the watchlist. The websocket would be active most of the times, in case there's a downtime, it would be back up in 2 hours.
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
