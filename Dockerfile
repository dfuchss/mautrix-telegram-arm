FROM alpine:3.15 AS builder

RUN apk add --no-cache git build-base cmake libpng-dev zlib-dev

# Install rlottie
RUN git clone https://github.com/Samsung/rlottie.git && cd rlottie && git checkout bd4c4e1
WORKDIR /rlottie/build
RUN cmake .. && make install

WORKDIR /
RUN git clone https://github.com/sot-tech/LottieConverter && cd LottieConverter && git checkout e515646
RUN cd LottieConverter && make CONF=Release

FROM alpine:3.15

# Copy Lottie Converter
COPY --from=builder /usr/lib/librlottie.so* /usr/lib/
COPY --from=builder /LottieConverter/dist/Release/GNU-Linux/lottieconverter /usr/bin/lottieconverter
RUN apk add --no-cache zlib libpng libjpeg-turbo-dev zlib-dev

RUN apk add --no-cache \
      python3 py3-pip py3-setuptools py3-wheel \
      py3-virtualenv \
      py3-pillow \
      py3-aiohttp \
      py3-magic \
      py3-ruamel.yaml \
      py3-commonmark \
      py3-prometheus-client \
      # Indirect dependencies
      py3-idna \
      #moviepy
        py3-decorator \
        py3-tqdm \
        py3-requests \
        #imageio
          py3-numpy \
      #py3-telethon \ (outdated)
        # Optional for socks proxies
        py3-pysocks \
        py3-pyaes \
        # cryptg
          py3-cffi \
	  py3-qrcode \
      py3-brotli \
      # Other dependencies
      ffmpeg \
      ca-certificates \
      su-exec \
      netcat-openbsd \
      # encryption
      py3-olm \
      py3-pycryptodome \
      py3-unpaddedbase64 \
      py3-future \
      bash \
      curl \
      jq \
      yq

COPY requirements.txt /opt/mautrix-telegram/requirements.txt
COPY optional-requirements.txt /opt/mautrix-telegram/optional-requirements.txt
WORKDIR /opt/mautrix-telegram
RUN apk add --virtual .build-deps python3-dev libffi-dev build-base \
 && pip3 install -r requirements.txt -r optional-requirements.txt \
 && apk del .build-deps

COPY . /opt/mautrix-telegram
RUN apk add git && pip3 install .[all] && apk del git \
  # This doesn't make the image smaller, but it's needed so that the `version` command works properly
  && cp mautrix_telegram/example-config.yaml . && rm -rf mautrix_telegram

VOLUME /data
ENV UID=1337 GID=1337 \
    FFMPEG_BINARY=/usr/bin/ffmpeg

CMD ["/opt/mautrix-telegram/docker-run.sh"]
