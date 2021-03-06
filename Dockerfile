FROM scratch
MAINTAINER kjbreil <kjell.breiland@gmail.com>
ADD root.tar.xz /
RUN pacman-key --init && \
	pacman-key --populate archlinux && \
	pacman-key --refresh-keys && \
	locale-gen && \
	pacman -Syu --needed --noconfirm archlinux-keyring iproute2 \
	iputils procps-ng tar util-linux procps-ng \
	util-linux shadow sed gzip grep
CMD ["/bin/bash"]

# licenses pacman which