FROM scratch
MAINTAINER kjbreil <kjell.breiland@gmail.com>
ADD root.tar.xz /
RUN pacman-key --init && \
	pacman-key --populate
RUN locale-gen
RUN pacman -Syu --needed --noconfirm archlinux-keyring iproute2 \
	iputils procps-ng tar which licenses util-linux pacman procps-ng \
	util-linux shadow sed gzip grep
CMD ["/bin/bash"]