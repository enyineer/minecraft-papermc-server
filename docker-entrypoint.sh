#!/bin/sh
set -e

DOCKER_USER='dockeruser'
DOCKER_GROUP='dockergroup'

if ! id "$DOCKER_USER" >/dev/null 2>&1; then
    echo "First start of the docker container, start initialization process."

    USER_ID=${PUID:-9001}
    GROUP_ID=${PGID:-9001}
    echo "Starting with $USER_ID:$GROUP_ID (UID:GID)"

    addgroup --gid $GROUP_ID $DOCKER_GROUP
    adduser --shell /bin/sh --uid $USER_ID --ingroup $DOCKER_GROUP --disabled-password $DOCKER_USER

    chown -vR $USER_ID:$GROUP_ID /opt/minecraft
    chmod -vR ug+rwx /opt/minecraft
    chown -vR $USER_ID:$GROUP_ID /data
fi

export HOME=/home/$DOCKER_USER
exec su-exec $DOCKER_USER java -jar -Xms$MEMORYSIZE -Xmx$MEMORYSIZE $JAVAFLAGS /opt/minecraft/paperspigot.jar --nojline nogui