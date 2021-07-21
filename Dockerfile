FROM node:12.13

# bind to all network interfaces
ENV HOST=0.0.0.0

ENV CTF_SPACE_ID=6bya4tyw8399

ENV CTF_CDA_ACCESS_TOKEN=3s7uhMYPb0lU00oK71e1gL5gSjSkuJRqXdQGySImRCg

ENV CTF_API_HOST=cdn.contentful.com

COPY . /src

WORKDIR /src

RUN yarn install
