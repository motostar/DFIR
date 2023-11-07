## Favicon Search via Shodan

1.  Copy/clone this script into host with python 3 installed: 
    
2.  Update line 18 with the url(s) directing to the favicon. This should be in the form of a comma separated list. You can see the examples already there are [https://www.pfizer.com/sites/default/files/custom-favicon/favicon.ico.png](https://www.pfizer.com/sites/default/files/custom-favicon/favicon.ico.png) and https://www.bankofamerica.com/favicon.ico
    
3.  In the terminal enter the following commands separately to install the Shodan library and the mmh3 library: (This is just a one time thing - You will not need to do this more than once)
   
>     pip3  install  shodan
>     
>     pip3  install  mmh3==3.0.0

3.  Using the terminal, access the directory where you have saved this - for this example it would be:

> `cd  Desktop`

4.  Run this file, by entering:
    

> `python3  favicon.py`

5.  In the same directory where this file is saved, there should be a new .xlsx file created containing the results from shodan - with contents looking something like this: (You should see each corresponding favicon root domain in column A):
    

LINK TO EXAMPLE: [Example Shodan Results](https://docs.google.com/spreadsheets/d/1Mgg8JCPWMkofkC08t4j_7meQUZbm1pU3Pm5BtjVM8xk/edit?usp=sharing)

![](https://lh7-us.googleusercontent.com/KyCJVAJOGwbwYK72F9t7O1e2rttwSW8AyVjDE_lM1j0Wlv0SSVnmg73L3U1NGTC4VI7tVhGyh_PqzabfDRCRPCqMckaVZfmJg8bLQHExX5mVS7JPnK2ahP_WTEe3DE9ByqkNw7w2NtQAGlwh_nbv9YU)
