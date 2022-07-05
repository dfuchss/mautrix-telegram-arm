FROM alpine:3.16 AS builder

RUN apk add --no-cache git build-base cmake libpng-dev zlib-dev

# Install rlottie
RUN git clone https://github.com/Samsung/rlottie.git && cd rlottie && git checkout bd4c4e1
WORKDIR /rlottie/build
RUN cmake .. && make install

WORKDIR /
RUN git clone https://github.com/sot-tech/LottieConverter && cd LottieConverter && git checkout e515646
RUN cd LottieConverter && make CONF=Release

FROM alpine:3.16 AS cryptg

RUN apk add --no-cache rust cargo py3-pip py3-wheel py3-setuptools \
  && mkdir cryptg && cd cryptg \
  && wget https://github.com/cher-nov/cryptg/tarball/e5a86364e9fd77cadbea94d48e28fded0f2a6e1a -O cryptg.tar \
  && tar --strip-components 1 -xvf cryptg.tar \
  && pip install setuptools_rust \
  && python3 setup.py bdist_wheel \
  && mv dist/cryptg-*.whl /


FROM alpine:3.16

# Copy Lottie Converter
COPY --from=builder /usr/lib/librlottie.so* /usr/lib/
COPY --from=builder /LottieConverter/dist/Release/GNU-Linux/lottieconverter /usr/bin/lottieconverter
COPY --from=cryptg /cryptg-*.whl /

RUN apk add --no-cache zlib libpng libjpeg-turbo-dev zlib-dev

RUN apk add --no-cache \
      python3 py3-pip py3-setuptools py3-wheel \
      py3-pillow \
      py3-aiohttp \
      py3-magic \
      py3-ruamel.yaml \
      py3-commonmark \
      py3-phonenumbers \
      py3-mako \
      #py3-prometheus-client \ (pulls in twisted unnecessarily)
      # Indirect dependencies
      py3-idna \
      py3-rsa \
      #moviepy
        py3-decorator \
        py3-tqdm \
        py3-requests \
        #py3-proglog \
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
 && pip3 install /cryptg-*.whl \
 && pip3 install --no-cache-dir -r requirements.txt -r optional-requirements.txt \
 && apk del .build-deps \
 && rm -f /cryptg-*.whl

COPY . /opt/mautrix-telegram
RUN apk add git && pip3 install --no-cache-dir .[all] && apk del git \
  # This doesn't make the image smaller, but it's needed so that the `version` command works properly
  && cp mautrix_telegram/example-config.yaml . && rm -rf mautrix_telegram .git build

VOLUME /data
ENV UID=1337 GID=1337 \
    FFMPEG_BINARY=/usr/bin/ffmpeg

CMD ["/opt/mautrix-telegram/docker-run.sh"]
