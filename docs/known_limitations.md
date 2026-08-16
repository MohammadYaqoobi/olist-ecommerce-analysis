\# Known Data Limitations \& Design Decisions



This document records data quality issues discovered during the project and

the reasoning behind how each was handled — useful context for interpreting

the results, and a transparent record of the debugging process.



\## 1. Orphan Orders in RFM Segmentation (Fixed)

\*\*Issue:\*\* 611 orders had a valid (non-canceled) status but no matching rows

in `order\_items`. An `INNER JOIN` in the original `customer\_rfm` view

silently excluded these orders — and, in some cases, entire customers — from

the segmentation.

\*\*Resolution:\*\* Changed the join to `order\_items` to a `LEFT JOIN` with

`COALESCE(SUM(price), 0)` to preserve affected customers with a monetary

value of 0 rather than NULL.

\*\*Impact:\*\* Restored 571 previously-missing customers to the segmentation.



\## 2. City Name Duplicates from Collation Mismatch (Fixed)

\*\*Issue:\*\* MySQL's default collation (`utf8mb4\_0900\_ai\_ci`) is

accent-insensitive, so `GROUP BY city` silently merged accented and

non-accented spellings (e.g., "sao paulo" and "são paulo"). Power BI performs

exact, accent-sensitive comparisons, so the same city appeared twice once

imported.

\*\*Resolution:\*\* Identified all 190 affected city-name pairs via a self-join

comparison, built a mapping table (`city\_name\_fix`), and normalized

`geolocation\_clean.city` to the accented spelling.

\*\*Impact:\*\* Fixed at the `geolocation\_clean` table level only. Raw

`customers.customer\_city` and `sellers.seller\_city` were not normalized —

see item 5.



\## 3. Multiple Reviews per Order

\*\*Issue:\*\* 547 orders have more than one row in `olist\_order\_reviews`

(genuine separate reviews, not duplicate imports).

\*\*Resolution:\*\* Created `olist\_order\_reviews\_latest`, a deduplicated view

keeping only the most recent review per order. All order-level analysis

uses this view.



\## 4. Product Dimension Columns Stored as Text

\*\*Issue:\*\* Numeric columns in `olist\_products` (weight, dimensions) are

stored as `VARCHAR`, not a numeric type.

\*\*Resolution:\*\* Left unconverted — none of the 11 analytical questions

require these fields.



\## 5. Inconsistent Free-Text City Fields (Not Fixed)

\*\*Issue:\*\* Beyond accent variants, `sellers.seller\_city` and

`customers.customer\_city` contain typos, abbreviations, and invalid entries

(e.g., an email address in place of a city name).

\*\*Resolution:\*\* Not cleaned at the source. Where city-level accuracy

mattered, analysis joins through `zip\_code\_prefix` to the cleaned

`geolocation\_clean` table instead of the raw text field.



\## 6. 2016 Q3–Q4 Excluded from Cancellation Trend

\*\*Issue:\*\* Q3 2016 (n=4) and Q4 2016 (n=325) both show elevated cancellation

rates, but represent the platform's launch period — order volume grew \~16x

in the very next quarter.

\*\*Resolution:\*\* Excluded from the cancellation-rate trend via an explicit

launch-phase condition, separate from the general small-sample-size filter.



\## 7. Delivery Delay: Calendar Days vs. 24-Hour Periods

\*\*Issue:\*\* `DATEDIFF()` (calendar-day difference) and

`TIMESTAMPDIFF(DAY, ...)` (elapsed 24-hour periods) produce different

results for the same two timestamps.

\*\*Resolution:\*\* The calendar-day definition was adopted as official, both

in SQL and in the Power BI model.



\## 8. Repeat Customer Rate: Two Valid Definitions

\*\*Issue:\*\* RCR can be computed from raw order history (including canceled

orders, 3.12%) or from valid-orders-only history (3.06%).

\*\*Resolution:\*\* The valid-orders-only definition was adopted, for

consistency with the project's convention of excluding canceled orders from

behavioral metrics.



\## 9. Customers with No Successful Orders Are Excluded from RFM

\*\*Issue:\*\* 536 customers have order history consisting entirely of canceled

orders, and therefore have no Recency/Frequency/Monetary values.

\*\*Resolution:\*\* Documented as an intentional scope boundary: RFM

segmentation is defined over customers with at least one successful

purchase.

