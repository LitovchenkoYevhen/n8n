FROM n8nio/n8n

USER root
RUN npm install -g pnpm@10.2.1
RUN npm install -g youtube-transcript
USER node

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["n8n", "start"]
