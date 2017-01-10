FROM scratch
MAINTAINER kjbreil <kjell.breiland@gmail.com>
ADD root.tar.xz /
RUN pacman-key --init && \
	pacman-key --populate
RUN locale-gen
RUN pacman -Sy --needed --noconfirm archlinux-keyring
RUN pacman -Syu --needed --noconfirm iproute2 iputils procps-ng tar which licenses util-linux pacman
RUN pacman -S --needed --noconfirm procps-ng util-linux shadow sed gzip grep
CMD ["/bin/bash"]