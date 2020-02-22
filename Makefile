API_ROOT="https://sparkpsagot.ordernet.co.il/api"

all: credentials.json
	curl $(API_ROOT)/Auth/Authenticate \
	    -XPOST \
	    -f \
	    --data-binary "`cat $<`"\
	    -H "Content-Type: application/json"
