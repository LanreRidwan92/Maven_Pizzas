# From Dough to Dollars: Analyzing Maven Pizza's Story

## Introduction
Imagine stepping into a vibrant pizzeria bustling with activity—the aroma of freshly baked dough, the sizzle of melting cheese, and the joyous chatter of satisfied customers. Our mission is to uncover the secrets behind the success of this fictitious pizza haven, Maven Pizza, by delving into a year's worth of sales data. Through this journey, we aim to extract valuable insights to guide business decisions and elevate the pizzeria's operations to new heights.

## Statement of the Problem
Every great story begins with a mystery waiting to be solved. Maven Pizza presented us with intriguing questions. These questions set the stage for our analysis.

* How many customers do we have each day? Are there any peak hours?
* How many pizzas are typically in an order? Do we have any bestsellers?
* How much money did we make this year? Can we identify any seasonality in the sales?
* Are there any pizzas we should take off the menu, or any promotions we could leverage?

## About the Data

To bring this story to life, we worked with a dataset spanning four tables:

* Order Details Table: Detailed transaction records, including order specifics and quantities.
* Order Table: insights into the date and time orders were placed.
* Pizzas Type Table: Categories and names of various pizzas.
* Pizza Table: Information on pizza sizes and prices.

## Data Cleaning and Transformation

Like any good detective story, our journey began with tidying up the clues. MySQL was our tool of choice for data cleaning and transformation. First, we created duplicate tables for exploratory data analysis (EDA). Then, we tackled missing columns and duplicate rows using the `ROW_NUMBER` function and CTE tables to methodically clean each dataset.
data
Once the data was pristine, we transformed it to suit our analysis. Incorrect data types were corrected—'TEXT' became 'DATE' and 'TIME' where appropriate. We also extracted 'Month' and 'Day Session' columns from the Date and Time attributes, enabling us to unravel deeper patterns.

## Insights
The results of our analysis painted a vivid picture of Maven Pizza's performance:

* Customer Activity: Fridays, Thursdays, and Saturdays were the busiest days, with 3,538, 3,239, and 3,158 orders, respectively. Fridays attracted the most customers—8,106 in total—followed closely by Saturdays with 7,355.
* Peak Hours: Evening emerged as the peak time, with a whopping 26,490 orders. Afternoon followed with 19,437, while morning lagged with just 2,693 orders.
* Best and Least Sellers: The stars of our menu included Classic Deluxe Pizza, Barbecue Chicken Pizza, Hawaiian Pizza, Pepperoni Pizza, and Thai Chicken Pizza. Conversely, Brie Carre Pizza, Mediterranean Pizza, Calabrese Pizza, Spinach Supreme Pizza, and Soppressata Pizza struggled to make an impact.
* Seasonality and Revenue: July, May, and March were revenue-generating months, while October, September, and December saw lower earnings.
* Revenue superstars included Thai Chicken Pizza, BBQ Chicken Pizza, California Chicken Pizza, Classic Deluxe Pizza, and Spicy Italian Pizza. The least profitable were Brie Carre Pizza, Green Garden Pizza, Spinach Supreme Pizza, Mediterranean Pizza, and Spinach Pesto Pizza.

## Recommendations
* Targeted Promotions: Boost the sales of underperforming pizzas with special discounts or combo offers.
* Seasonal Campaign: Capitalize on high-performing months with targeted advertising and themed events.
* Menu Optimization: Consider retiring consistently underperforming pizzas or refining their recipes to better match customer preferences.
* Peak Hour Strategies: Ensure adequate staffing and inventory during evening hours to handle high demand seamlessly.

## Conclusion
Our exploration of Maven Pizza’s sales data revealed the intricacies of customer behavior, menu dynamics, and revenue trends. By leveraging these insights, Maven Pizza can delight its patrons while achieving operational excellence.

