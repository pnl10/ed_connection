# ed_connection

README

*A project by Jizhou Lei, Parker Lazear, and Kieran Connolly*

This project attempts to analyze the effect of broadband internet access on educational outcomes in West Virginia by using machine learning methods to analyze US Census data.

This project is available publicly at <https://github.com/pnl10/ed_connection>.

The project uses data from several sources:

-   **Income:** <https://data.census.gov/table/ACSST1Y2018.S1903?q=West%20Virginia%20income&g=040XX00US54$0500000,54$1400000&y=2018> The dataset was obtained from data.census.gov, which provides detailed survey information at the census tract level from the American Community Survey. Specifically, the variable of interest is median income in the past 12 months, designated by the code S1903, and is sourced from the ACS 5-Year data for 2018 in West Virginia.

-   **Broadband Internet Data:** <https://data.census.gov/table?q=West%20Virginia%20internet&g=040XX00US54$0500000,54$1400000> The dataset, also sourced from data.census.gov, focuses on the variable "Types of Computers and Internet Subscription," coded as S2801. The process for obtaining this dataset mirrors the earlier approach in terms of applying filters for geography and years.

-   **Educational Attainment:** <https://data.census.gov/table?q=West%20Virginia%20education&g=040XX00US54$0500000,54$1400000&y=2018> For the third dataset from data.census.gov, the focus is on the variable "Education Attainment" coded S1501. While the filters for geography and years remain consistent with the previous datasets, the topic filter used for this dataset specifically targets Education.
