ARG BASE=hieupth/tritonserverbuild:24.12

FROM ${BASE}
RUN pip install --no-cache-dir huggingface_hub tokenizers numpy
ADD ./scripts/* /