FROM innovanon/bare as builder
ARG EXT=tgz
ARG TEST=
#ARG LFS=/mnt/lfs
COPY          ./stage-6.$EXT    /tmp/
RUN sleep 31                                             \
 && tar xf /tmp/stage-6.$EXT -C /                        \
 && rm    -v                    /tmp/stage-6.$EXT        \
                                /.sentinel               \
 && chmod -v 1777               /tmp                     \
 && apt update                                           \
 && [ -x           /tmp/dpkg.list ]                      \
 && apt install  $(/tmp/dpkg.list)                       \
 && rm -v          /tmp/dpkg.list                        \
 && apt autoremove                                       \
 && apt clean                                            \
 && rm -rf /tmp/*                                        \
           /var/log/alternatives.log                     \
           /var/log/apt/history.log                      \
           /var/lib/apt/lists/*                          \
           /var/log/apt/term.log                         \
           /var/log/dpkg.log                             \
           /var/tmp/*

# TODO take this out until shc -S is an option
FROM builder as support
ARG EXT=tgz
ARG TEST=
COPY          ./stage-7.$EXT    /tmp/
RUN tar xf /tmp/stage-7.$EXT -C /                  \
 && rm    -v                    /tmp/stage-7.$EXT  \
                                /.sentinel         \
 && chmod -v 1777               /tmp               \
 && apt update                                     \
 && [ -x            /tmp/dpkg.list ]               \
 && apt install   $(/tmp/dpkg.list)                \
 && cd /usr/local/bin                              \
 && shc -rUf     dl                                \
 && rm    -v     dl.x.c                         \
 && chmod -v 0555 dl.x                             \
 && apt-mark auto $(/tmp/dpkg.list)                \
 && rm -v           /tmp/dpkg.list                 \
 && apt autoremove                                 \
 && apt clean                                      \
 && rm -rf /tmp/*                                  \
           /var/log/alternatives.log               \
           /var/log/apt/history.log                \
           /var/lib/apt/lists/*                    \
           /var/log/apt/term.log                   \
           /var/log/dpkg.log                       \
           /var/tmp/*
 #&& rm    -v     dl{,.x.c}                         \

FROM builder as final
ARG EXT=tgz
##ARG LFS=/mnt/lfs
# TODO
#COPY --from=support --chown=root /usr/local/bin/dl.x /usr/local/bin/dl
COPY --from=support --chown=root /usr/local/bin/dl /usr/local/bin/dl

##COPY          ./stage-7.$EXT    /tmp/
##RUN tar xf /tmp/stage-7.$EXT -C /                        \
# && rm    -v                    /tmp/stage-7.$EXT        \
#                                /.sentinel               \
# && chmod -v 1777               /tmp
## && apt update                                           \
## && [ -x           /tmp/dpkg.list ]                      \
## && apt install  $(/tmp/dpkg.list)                       \
## && rm -v          /tmp/dpkg.list                        \
## && apt autoremove                                       \
## && apt clean                                            \
## && rm -rf /tmp/*                                        \
##           /var/log/alternatives.log                     \
##           /var/log/apt/history.log                      \
##           /var/lib/apt/lists/*                          \
##           /var/log/apt/term.log                         \
##           /var/log/dpkg.log                             \
##           /var/tmp/*
## TODO clean script; rm clean script here

#FROM final as test
#USER lfs
#RUN sleep 31 \
# && tsocks wget -O- https://3g2upl4pq6kufc4m.onion

#FROM final

