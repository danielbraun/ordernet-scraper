API_ROOT=https://sparkpsagot.ordernet.co.il/api

all: out/DailyYield/2020.csv out/BatchData

%.csv: %.json
	cat $< | json2csv > $@

out/DailyYield/%.json: out/curl.config out/BatchData.json
	mkdir -p `dirname $@`
	curl "$(API_ROOT)/Account/GetAccountDailyYields?accountKey=$(shell jq -r ".[] | select(.b == \"ACC\") | .a[0]._k" < out/BatchData.json)&year=$*" \
	    -K $< > $@

out/BatchData/%.json: out/BatchData.json
	mkdir -p $(@D)
	cat $< | jq '.[] | select(.b == "$*") | .a' > $@

out/BatchData: out/BatchData.json
	$(MAKE) $(shell echo $@/{$(shell cat $< | jq -r 'map(.b)[]' | head | paste -sd , -)}.csv)

out/PersonalUserData.json: out/curl.config
	curl $(API_ROOT)/UserPersonalization/GetUserData -K $< | jq > $@

out/BatchData.json: out/curl.config
	curl $(API_ROOT)/DataProvider/GetStaticData -K $< | jq > $@

out/SystemStatus.json: out/curl.config
	curl $(API_ROOT)/UserPersonalization/GetStatus -K $< | jq > $@

out/curl.config: out/AuthResult.json
	printf -- '-f\n-H "Authorization: Bearer %s"' $(shell jq ".l" -r < $<) > $@

out/AuthResult.json: credentials.json
	mkdir -p `dirname $@`
	curl $(API_ROOT)/Auth/Authenticate \
	    -XPOST \
	    -f \
	    --data-binary "`cat $<`"\
	    -H "Content-Type: application/json" \
	    | jq \
	    > $@

clean:
	rm -r out/*

.PHONY: clean
