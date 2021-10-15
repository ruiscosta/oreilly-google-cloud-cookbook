-- Copyright 2021, Google, Inc.
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     http://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- insert values
INSERT INTO
  Customers (CustomerId,
    FirstName,
    LastName,
    Address)
VALUES
  (1, "Rui", "Costa", "123 Main Street"),
  (2, "Drew", "Hodun", "456 Park Ave");
INSERT INTO
  Orders (OrderId,
    CustomerId,
    OrderTotal,
    QuantityItems,
    OrderItems)
VALUES
  (1, 1, 52.34, 2, [398473, 47402]),
  (2, 1, 983.12, 3, [934773, 304983, 3872]),
  (3, 2, 10.15, 1, [3872])

-- aggregate query
SELECT
  Customers.CustomerId,
  Customers.FirstName,
  Customers.LastName,
  SUM(Orders.orderTotal) AS total_spent
FROM
  Orders
JOIN
  Customers
ON
  Orders.CustomerId = Customers.CustomerId
GROUP BY
  Customers.CustomerId,
  Customers.FirstName,
  Customers.LastName