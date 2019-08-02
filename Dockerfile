FROM archlinux/base:latest

RUN pacman --noconfirm -Sy archlinux-keyring && pacman-key --init && pacman-key --populate archlinux
RUN pacman -Sy --noconfirm --need base-devel git
RUN pacman -Sy --noconfirm curl

RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN /usr/bin/groupadd --system sudo && \
  /usr/sbin/useradd -m --groups sudo user
USER user
RUN mkdir -p /tmp/install && cd /tmp/install  && \
  curl -O -L https://github.com/actionless/pikaur/archive/1.4.3.tar.gz  && \
  tar xf 1.4.3.tar.gz && cd pikaur-1.4.3 && makepkg -fsri --noconfirm
# following file is missing read permissions for some reasons
RUN sudo chmod a+r /usr/lib/python3.7/site-packages/pikaur/srcinfo.py
RUN pikaur --aur -Sy --noconfirm python-spglib openblas-lapack
RUN pikaur --aur -Syu --noconfirm ipython-ipyparallel
RUN pikaur -Syu --noconfirm  gcc-fortran cmake ipython jupyterlab
RUN pikaur --aur -Syu --noconfirm  lmod libxc
RUN pikaur -Syu --noconfirm spglib

RUN mkdir -p /tmp/sirius
COPY --chown=user PKGBUILD /tmp/sirius
RUN cd /tmp/sirius && \
  makepkg -fsri --noconfirm

RUN sudo pacman --noconfirm -Sc; exit 0

COPY --chown=user examples /home/user

WORKDIR /home/user
ENTRYPOINT ["jupyter", "lab", "--ip=*", "--no-browser"]
