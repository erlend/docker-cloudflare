# Cloudflare

A tiny docker container for updating a Cloudflare DNS A record with the current
external IP address.

## Configuration

| Variable     | Description                                                |
| ------------ | ---------------------------------------------------------- |
| CF_ZONE_ID   | The `Zone ID` found on your Cloudflare overview page       |
| CF_API_KEY   | The `Global API Key` found on your Cloudflare account page |
| CF_EMAIL     | The email address used to log into Cloudflare              |
| CF_DOMAIN    | The FQDN you want to update the IP address for             |
| CRON_PATTERN | When to run the script, defaults to hourly (`0 * * * *`)   |

## Example

There is no ports to forward or volumes to mount. Just specify the variables
starting with `CF_` and run the container.

    $ docker run --rm -e CF_ZONE_ID=... erlend/cloudflare
