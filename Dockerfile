FROM mcr.microsoft.com/playwright:v1.52.0-noble
ENV DEBIAN_FRONTEND=noninteractive PNPM_HOME=/pnpm PATH=/home/agent/.cargo/bin:/pnpm:$PATH PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl build-essential pkg-config libssl-dev git && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal && corepack enable && corepack prepare pnpm@10.17.0 --activate && useradd --create-home --shell /bin/bash --uid 10001 agent && mkdir -p /workspace /pnpm && chown -R agent:agent /workspace /pnpm /home/agent && rm -rf /var/lib/apt/lists/*
WORKDIR /workspace
COPY --chown=agent:agent . .
USER agent
RUN pnpm install --frozen-lockfile
EXPOSE 52800 5173
CMD ["pnpm", "cli:build"]
