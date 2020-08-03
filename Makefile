API_ROOT=https://sparkpsagot.ordernet.co.il/api

all: \
    out/UserPersonalization/GetUserData.json \
    out/DataProvider/GetStaticData.json \
    out/UserPersonalization/GetStatus.json \
    out/Account/GetHoldings.csv \
    out/Account/GetHoldings.psql.csv \
    out/Account/GetAccountTransactions.csv \
    out/Account/GetAccountTransactions.psql.csv \
    out/DailyYield/2020.csv \
    ordernet.schema.psql.sql

%.csv: %.json; cat $< | json2csv | csvformat > $@

out/accountKey: out/DataProvider/GetStaticData/ACC.json
	jq -r '.[0].a._k' < $< > $@

out/Account/GetAccountTransactions.json: out/curl.config out/accountKey
	@mkdir -p $(@D)
	curl $(API_ROOT)/Account/GetAccountTransactions \
	    -G \
	    --data-urlencode 'accountKey=$(shell cat out/accountKey)' \
	    --data-urlencode 'startDate=$(shell gdate -Iseconds -u -d "-1 year")' \
	    --data-urlencode 'endDate=$(shell gdate -Iseconds -u)' \
	    -K $< \
	    -o $@

out/Account/%.json: out/curl.config out/accountKey
	@mkdir -p $(@D)
	curl $(API_ROOT)/Account/$* \
	    -G \
	    --data-urlencode 'accountKey=$(shell cat out/accountKey)' \
	    -K $< \
	    > $@

out/DailyYield/%.json: out/curl.config out/accountKey
	mkdir -p $(@D)
	curl "$(API_ROOT)/Account/GetAccountDailyYields" \
	    -G \
	    --data-urlencode 'accountKey=$(shell cat out/accountKey)' \
	    --data-urlencode 'year=$*' \
	    -K $< > $@

out/DataProvider/GetStaticData/%.json: out/DataProvider/GetStaticData.json
	mkdir -p $(@D)
	cat $< | jq '.[] | select(.b == "$*") | .a' > $@

out/DataProvider/GetStaticData: out/DataProvider/GetStaticData.json
	@$(MAKE) $(shell echo $@/{$(shell cat $< | jq -r 'map(.b)[]' | paste -sd , -)}.csv)

out/dividend_calendar.ics: templates/icalendar.jinja2
	psql -t -A -c "select json_build_object('events',json_agg(row_to_json(a))) from ordernet.calendar_events a;" \
	    | jinja2 $< -o $@

out/%.json: out/curl.config
	mkdir -p $(@D)
	curl $(API_ROOT)/$* -K $< > $@

out/curl.config: templates/curl.jinja2 out/AuthResult.json
	jinja2 $^ -o $@

out/AuthResult.json: credentials.json
	mkdir -p $(@D)
	curl $(API_ROOT)/Auth/Authenticate \
	    -f \
	    --data-binary @$< \
	    -H "Content-Type: application/json" \
	    > $@
	jq -e '.a != "ServerNotReady"' < out/AuthResult.json

clean:
	rm -r out/*

%.html: %.sql
	cat $< | psql --html -o $@

%.schema.psql.sql:
	pg_dump \
	    --no-owner \
	    --no-privileges \
	    --schema-only \
	    -n $(shell basename $*) \
	    > $@

%.psql.csv: %.csv
	echo "begin; truncate :table; copy :table from '$(shell realpath $<)' csv header; copy :table to stdout csv header; commit;" | psql \
	    -v table=ordernet.\"$(shell basename $*)\" \
	    -o $@
.PHONY: clean
