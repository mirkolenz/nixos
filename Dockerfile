FROM ubuntu:latest

ADD https://install.determinate.systems/nix /nix-installer

RUN apt update --yes \
    && apt install curl git --yes \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /nix-installer \
    && /nix-installer install linux --init none --no-confirm

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

WORKDIR /etc/nixos

CMD ["bash"]
