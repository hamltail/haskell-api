FROM haskell:9.10.3

WORKDIR /app

COPY haskell-api.cabal ./
COPY app ./app
COPY src ./src
COPY data ./data

RUN cabal update \
    && cabal build \
    && cp "$(cabal list-bin exe:haskell-api)" /usr/local/bin/haskell-api

EXPOSE 3000

CMD ["haskell-api"]
