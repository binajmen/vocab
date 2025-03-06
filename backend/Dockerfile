FROM ghcr.io/gleam-lang/gleam:v1.8.1-erlang

# Add project code
COPY . /build/

# Compile the project
RUN cd /build \
	&& gleam export erlang-shipment \
	&& mv build/erlang-shipment /app \
	&& rm -r /build

# Run the server
WORKDIR /app
EXPOSE 8010/tcp
ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["run"]
