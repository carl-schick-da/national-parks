from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry
from bs4 import BeautifulSoup
import pandas as pd
import requests
import re

def get_connection_info():
    # Configure HTTP components for web browser immitation and retry sessions

    # User Agent makes us look like a web browser to avoid connection denials
    user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36'
    headers = {'User-Agent': user_agent}

    # Setup retry strategy and attach it to the http adapter
    retry_strategy = Retry(
        total=3,
        backoff_factor=1,
        status_forcelist=[429, 500, 502, 503, 504],
        allowed_methods=["HEAD", "GET", "OPTIONS"]
    )
    adapter = HTTPAdapter(max_retries=retry_strategy)
    http = requests.Session()
    http.mount("https://", adapter)
    http.mount("http://", adapter)

    # Return the http adapater (with retries configured) and the headers variable with a user agent that looks like a browser
    return http, headers

########################

# Get connection info
http, headers = get_connection_info()

park_unit = pbi_args[0]
if len(park_unit) == 0:
    park_unit = 'YOSE'

# Base page for manual retrieval is at URL 'https://irma.nps.gov/STATS/'
# Setup URL and Query String for coded retrieval
park_visits_domain = 'https://irma.nps.gov'
park_visits_url = '/STATS/SSRSReports/Park%20Specific%20Reports/Recreation%20Visitors%20By%20Month%20(1979%20-%20Last%20Calendar%20Year)'
park_visits_qs = '?Park='

# Create an empty dataframe to hold the results
# When the data is scraped, the HTML has many duplicate tables with like headings.  We find the right table my looking for the one that has multiple rows.
# The target_table_min literal identifies the number of rows a table must have in order for it to be considered the valid table we are looking for.
park_visits_df = pd.DataFrame()
target_table_min = 10

# The first call will get the SSRS wrapper
park_visits_request = park_visits_domain + park_visits_url + park_visits_qs + park_unit
r = http.get(park_visits_request, headers=headers, timeout=5)

# Use Beautiful Soup to extract the source (src) of the iframe that contains the actual data
soup = BeautifulSoup(r.text, 'html.parser')
park_visits_iframe = soup.find('iframe').attrs['src']

# Make a second call to the iframe's src URL to get the actual data
park_visits_request = park_visits_domain + park_visits_iframe
r = http.get(park_visits_request, headers=headers, timeout=5)

# Use pandas to read in the html and find the target table
dfs = pd.read_html(r.text, match="Year", skiprows=1)
for df in dfs:
    if len(df) > target_table_min: park_visits_df = df

# park_visits_df.insert(0, "-1", park_unit)
# park_visits_df.iat[0,0] = "Park Unit"

print(park_visits_df)