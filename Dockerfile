FROM ubuntu:24.04
RUN apt-get update \
 && apt-get install -y ca-certificates curl tar

RUN groupadd -g 10100 teamtalk \
 && useradd -u 10100 -g 10100 -M -s /usr/sbin/nologin teamtalk

ENV TT_CFG_DIR=/etc/teamtalk \
 TT_DATA_DIR=/var/lib/teamtalk \
 TT_LOG_DIR=/var/log/teamtalk

 RUN install -d -m 0750 -o teamtalk -g teamtalk $TT_CFG_DIR $TT_DATA_DIR $TT_LOG_DIR
WORKDIR /tmp/tt
RUN curl -fsSL -o tt.tgz "https://bearware.dk/teamtalk/v5.19/teamtalk-v5.19-ubuntu24-x86_64.tgz" \
&& tar -xzf tt.tgz \
&& cp ./teamtalk-v*/server/tt5srv /usr/local/bin/tt5srv \
&& chmod 0755 /usr/local/bin/tt5srv \
&& rm -rf /tmp/tt
USER teamtalk:teamtalk
EXPOSE 10333/udp
EXPOSE 10333/tcp
CMD ["sh","-c","exec /usr/local/bin/tt5srv -nd -c $TT_CFG_DIR/tt5srv.xml -l $TT_LOG_DIR/tt5srv.log"]