FROM php:8.1-cli


LABEL version="1.0"
LABEL maintainer="Amir Alian <amir@ateli.cz>"

COPY "entrypoint.sh" "/entrypoint.sh"
COPY "openmage_files_v1.6.txt" "/openmage_files_v1.6.txt"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y jq

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
