FROM rocketchat/base:8

ENV RC_VERSION 0.65.2

MAINTAINER buildmaster@rocket.chat

RUN set -x \
 && curl -SLf "https://releases.rocket.chat/${RC_VERSION}/download/" -o rocket.chat.tgz \
 && curl -SLf "https://releases.rocket.chat/${RC_VERSION}/asc" -o rocket.chat.tgz.asc \
 && gpg --verify rocket.chat.tgz.asc \
 && mkdir -p /app \
 && tar -zxf rocket.chat.tgz -C /app \
 && rm rocket.chat.tgz rocket.chat.tgz.asc \
 && cd /app/bundle/programs/server \
 && npm install \
 && npm cache clear --force \
 && chown -R rocketchat:rocketchat /app

USER rocketchat

VOLUME .

WORKDIR .

# needs a mongoinstance - defaults to container linking with alias 'mongo'
ENV DEPLOY_METHOD=docker \
    NODE_ENV=production \
    MONGO_URL=mongodb://mongo:27017/rocketchat \
    HOME=/tmp \
    PORT=4100 \
    ROOT_URL=http://localhost:4100 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 4100

CMD ["node", "index.js"]
