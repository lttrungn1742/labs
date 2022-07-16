
FROM fluent/fluent-bit:1.3.3

ENV TZ='Asia/Tokyo'
COPY ./fluent_bit.conf /fluent-bit/etc/fluent_bit_custom.conf
COPY ./stream_processor.conf /fluent-bit/etc/stream_processor_custom.conf
COPY ./parser.conf /fluent-bit/etc/parser_custom.conf


CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent_bit_custom.conf"]