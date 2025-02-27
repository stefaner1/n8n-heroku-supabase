#!/bin/sh

# Check if PORT variable is set; if not, use N8N's default port.
if [ -z "${PORT+x}" ]; then
  echo "PORT variable not defined, leaving N8N to default port."
else
  export N8N_PORT="$PORT"
  echo "N8N will start on port '$PORT'."
fi

# Ensure DATABASE_URL is provided
if [ -z "$DATABASE_URL" ]; then
  echo "Error: DATABASE_URL environment variable is not set."
  exit 1
fi

# regex function to parse URL
parse_url() {
  eval $(echo "$1" | sed -e "s#^\(\(.*\)://\)\?\(\([^:@]*\)\(:\(.*\)\)\?@\)\?\([^/?]*\)\(/\(.*\)\)\?#${PREFIX:-URL_}SCHEME='\2' ${PREFIX:-URL_}USER='\4' ${PREFIX:-URL_}PASSWORD='\6' ${PREFIX:-URL_}HOSTPORT='\7' ${PREFIX:-URL_}DATABASE='\9'#")
}

# Parse DATABASE_URL using a prefix to avoid conflicts
PREFIX="N8N_DB_"
parse_url "$DATABASE_URL"

# Optional: log the parsed database connection (beware of exposing credentials in logs)
echo "Parsed DATABASE_URL: $N8N_DB_SCHEME://$N8N_DB_USER:******@$N8N_DB_HOSTPORT/$N8N_DB_DATABASE"

# Separate host and port from the HOSTPORT component
N8N_DB_HOST="$(echo "$N8N_DB_HOSTPORT" | sed -e 's,:.*,,g')"
N8N_DB_PORT="$(echo "$N8N_DB_HOSTPORT" | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"

# Export DB connection variables for n8n
export DB_TYPE=postgresdb
export DB_POSTGRESDB_HOST="$N8N_DB_HOST"
export DB_POSTGRESDB_PORT="$N8N_DB_PORT"
export DB_POSTGRESDB_DATABASE="$N8N_DB_DATABASE"
export DB_POSTGRESDB_USER="$N8N_DB_USER"
export DB_POSTGRESDB_PASSWORD="$N8N_DB_PASSWORD"

# Ensure SSL flag is set (required for Supabase/Postgres connections on Heroku)
if [ -z "${DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED+x}" ]; then
  export DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED="false"
fi

# Start n8n
n8n
