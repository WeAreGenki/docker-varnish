# Varnish Cache Docker Image

[![](https://images.microbadger.com/badges/image/wearegenki/varnish.svg)](https://microbadger.com/images/wearegenki/varnish "Get your own image badge on microbadger.com") [![GitHub Tag](https://img.shields.io/github/tag/wearegenki/docker-varnish.svg)](https://registry.hub.docker.com/u/wearegenki/varnish/)

Minimal Varnish cache docker image running on an Alpine Linux base.

## Usage

If you're on the command-line you can run:

```
docker run -d \
  --name your-varnish \
  -v /mnt/your-data-dir/varnish/default.vcl:/etc/varnish/default.vcl:ro \
  -e VARNISH_MEMORY=128M \
  -e VARNISH_PORT=8080 \
  wearegenki/varnish:latest
```

## Licence

ISC. See [LICENCE.md](https://github.com/WeAreGenki/docker-varnish/blob/master/LICENCE.md).

## Author

Proudly made by Max Milton &lt;<max@wearegenki.com>&gt;.

&copy; We Are Genki
