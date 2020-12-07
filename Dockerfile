FROM php:7.4-cli


LABEL version="1.0"
LABEL maintainer="Amir Alian <amir@ateli.cz>"

COPY "entrypoint.sh" "/entrypoint.sh"
COPY "openmage_files.txt" "/openmage_files.txt"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y jq

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
