# Railway Configuration

This project has two deployment methods:

## 1. Web Deployment (Recommended)
Uses configuration files:
- `railway.json` - Main Railway configuration
- `nixpacks.toml` - Build process configuration

These files are used when deploying through Railway's web interface or GitHub integration.

## 2. CLI Deployment
For CLI deployment using `railway up` command:
1. Temporarily rename or move the config files:
   ```bash
   mv railway.json railway.json.web
   mv nixpacks.toml nixpacks.toml.web
   ```
2. Run `railway up`
3. After deployment, you can restore the files:
   ```bash
   mv railway.json.web railway.json
   mv nixpacks.toml.web nixpacks.toml
   ```
