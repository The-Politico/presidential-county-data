#!/bin/bash

psql prescounty -c "create or replace view clintontrump as
select 
    county_fips, 
    sum(case when((party = 'democratic' or party = 'democrat') and candidate_normalized = 'party') or (candidate_normalized = 'clinton') then "votes" end) as democrat, 
    sum(case when (party = 'republican' and candidate_normalized = 'party') or (candidate_normalized = 'trump') then "votes" end) as republican, 
    sum(votes) as total
from sixteen
where candidate_normalized != 'in'
group by county_fips
"

psql prescounty -c "copy (select * from clintontrump) to '`pwd`/output/2016.csv' with CSV HEADER;"