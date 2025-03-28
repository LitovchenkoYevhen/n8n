FROM n8nio/n8n

USER root
RUN npm install -g n8n-nodes-youtube-transcription
USER node

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["n8n", "start"]
