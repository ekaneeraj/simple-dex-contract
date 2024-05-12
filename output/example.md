
<!-- Address -->
TokenA 0xF1658C13F35cA105813a513c3789670Eef8011Ad
TokenB 0x7FDe0dCb82c5CBB4A3594e15e0823Da6c0cc9168
Contract 0x4D6BF6901C53a7DE5D99E03369f6aCa2cfa2772D
User 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB

<!-- Deploy -->
SimpleDex deploying with exchange rate 100

Error when both token addresses are same ![alt text](image-49.png)
Error when token address(es) is/are zero ![alt text](image-50.png)
Success when deployed ![alt text](image-51.png)

<!-- Initial balance of user and contract -->
Contract Token A Initial Balance (10e18) ![alt text](image-52.png)

Contract Token B Initial Balance (1000e18) ![alt text](image-53.png)

User's Token A Initial Balance (2000e18) ![alt text](image-54.png)
User's Token B Initial Balance (2000e18) ![alt text](image-55.png)

<!-- Exchange Token A for Token B -->
Approved 1000e18 TokenA to spend by simpleDEX ![alt text](image-56.png)
Exchanged, 1000e18 TokenA user got 1000e18 / 100 -> 10e18 TokenB ![alt text](image-58.png) ![alt text](image-59.png)

<!-- Balance of user and contract after 1st exchange -->
TokenAForB Contract Token A balance (10e18 + 1000e18 -> 1010e18)  ![alt text](image-62.png)
TokenAForB Contract Token B balance (1000e18 - 9e18 -> 990e18)  ![alt text](image-63.png)

TokenAForB User's Token A balance (2000e18 - 1000e18 -> 1000e18) ![alt text](image-61.png)
TokenAForB User's Token B balance (2000e18 + 10e18 -> 2010e18) ![alt text](image-60.png)


<!-- Exchange Token B for Token A -->
Error Approved 20e18 TokenB to get Token A ![alt text](image-66.png)

Expected: Insufficient balance for token A,  20e18 * 100 -> 2000e18 but token A available in contract 1010e18   ![alt text](image-67.png)

Success
Approved 2e18 TokenA to get Token A, 2e18 * 100 -> 200e18  ![alt text](image-68.png) ![alt text](image-69.png)

<!-- Balance of user and contract after 1st exchange -->
TokenBForA Contract Token A balance  1010e18 - 200e18 -> 810e18  ![alt text](image-73.png)
TokenBForA Contract Token B balance 990e18 + 2e18 -> 992e18  ![alt text](image-74.png)

TokenBForA User's Token A balance 1000e18 + 200e18 -> 1200e18 ![alt text](image-71.png)
TokenBForA User's Token B balance 2010e18 - 2e18 -> 2008e18 ![alt text](image-72.png)


<!-- Exchange rate  -->
Initial exchange rate (100) ![alt text](image-2.png)

Error If normal user tries to update exchange rate ![alt text](image-3.png)
Admin Error if value is 0 ![alt text](image-5.png)
Admin can update exchange rate ![alt text](image-4.png)