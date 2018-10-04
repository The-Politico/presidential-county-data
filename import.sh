#!/bin/bash

csvstack original/2012/*.csv > original/2012/us.csv

echo "Create database"
dropdb --if-exists prescounty
createdb prescounty

echo "Import 2016 data to database"
psql prescounty -c "CREATE TABLE sixteen (
    year char(4),
    stage char(3),
    special boolean,
    state varchar,
    state_postal char(2),
    state_fips char(2),
    state_icpsr char(2),
    county_name varchar,
    county_fips varchar,
    county_ansi char(8),
    county_lat decimal,
    county_long decimal,
    jurisdiction varchar,
    precinct varchar,
    candidate varchar,
    candidate_normalized varchar,
    office varchar,
    district varchar,
    writein boolean,
    party varchar,
    mode varchar,
    votes integer,
    candidate_opensecrets varchar,
    candidate_wikidata varchar,
    candidate_party varchar,
    candidate_last varchar,
    candidate_first varchar,
    candidate_middle varchar,
    candidate_full varchar,
    candidate_suffix varchar,
    candidate_nickname varchar,
    candidate_fec varchar,
    candidate_fec_name varchar,
    candidate_google varchar,
    candidate_govtrack varchar,
    candidate_icpsr varchar,
    candidate_maplight varchar
);"
psql prescounty -c "COPY sixteen from '`pwd`/original/2016/2016-precinct-president.csv' DELIMITER ',' CSV HEADER;"

psql prescounty -c "UPDATE sixteen SET county_fips = LEFT(county_fips, 5)"

psql prescounty -c "CREATE TABLE twelve (
    fips varchar,
    county varchar,
    candidate varchar,
    votes integer
)"
psql prescounty -c "COPY twelve from '`pwd`/original/2012/us.csv' DELIMITER ',' CSV HEADER;"