# docker-h5ai

Super simple Docker image for serving files with h5ai + basic auth.

## Run

```bash
docker run --rm -p 8080:80 \
	-v .:/app/files:ro \
	-e HT_PASSWORD="your-password" \
	docker-h5ai
```

- Mount your host files into `/app/files`.
- Set `HT_PASSWORD` to the password you want for HTTP basic auth.
- Log in with username `admin` and the password from `HT_PASSWORD`. The username is fixed and cannot be changed.
