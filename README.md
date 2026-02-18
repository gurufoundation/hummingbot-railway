# Hummingbot Railway Deployment

One-click deploy Hummingbot trading bot to Railway for 24/7 cloud hosting.

## Features

- ✅ **Paper Trading Mode** - Test strategies with fake money
- ✅ **Auto-Start Strategy** - Runs 24/7 without manual intervention
- ✅ **Persistent Storage** - Configs and logs survive restarts
- ✅ **Multiple Strategies** - Pure Market Making, Arbitrage, and more
- ✅ **Secure** - Runs in isolated Docker container

## Quick Deploy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/YOUR_TEMPLATE_ID)

Or manually:

1. Fork this repo to your GitHub
2. Connect repo to Railway
3. Deploy!

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PAPER_TRADE` | Enable paper trading mode | `true` |
| `STRATEGY` | Strategy to auto-start | `pure_market_making` |
| `CONFIG_PASSWORD` | Password for config encryption | (none) |

### Available Strategies

1. **pure_market_making** - Place buy/sell orders around mid price
2. **arbitrage** - Exploit price differences between exchanges
3. **avellaneda_market_making** - Advanced market making with inventory management
4. **cross_exchange_market_making** - Market make across multiple exchanges

### Paper Trading

When `PAPER_TRADE=true`, Hummingbot uses fake money with these starting balances:
- USDT: 10,000
- BTC: 0.5
- ETH: 5.0
- SOL: 1,000

## Monitoring

### View Logs
```bash
# SSH into Railway container
railway connect

# View logs
tail -f /home/hummingbot/logs/logs_hummingbot.log
```

### Health Check
The bot exposes a health endpoint at `https://your-app.up.railway.app/health`

## Strategies Explained

### Pure Market Making
- Places buy orders below market price
- Places sell orders above market price
- Earns the spread when both fill
- Best for: Stable markets with volume

### Arbitrage
- Monitors price differences between exchanges
- Buys low on Exchange A
- Sells high on Exchange B
- Best for: Volatile markets with exchange price gaps

## Customization

### Add Real Exchange API Keys

⚠️ **WARNING**: Only do this after extensive paper trading testing!

1. Go to Railway dashboard → Variables
2. Add your exchange API keys:
   - `BINANCE_API_KEY`
   - `BINANCE_SECRET_KEY`
   - `KUCOIN_API_KEY`
   - etc.

3. Set `PAPER_TRADE=false`
4. Redeploy

### Modify Strategy Parameters

Edit the config files in `conf/` directory:
- `conf_pure_market_making_1.yml` - Market making settings
- `conf_arbitrage_1.yml` - Arbitrage settings

Key parameters to adjust:
- `bid_spread` / `ask_spread` - How far from mid price to place orders
- `order_amount` - Size of each order
- `min_profitability` - Minimum profit % for arbitrage

## Security

- ✅ No private keys stored in repo
- ✅ API keys stored in Railway environment variables (encrypted)
- ✅ SSL certificates auto-generated
- ✅ Isolated Docker container

## Troubleshooting

### Bot won't start
Check Railway logs: `railway logs`

### Strategy not found
Make sure `STRATEGY` env var matches a valid strategy name

### Connection errors
- Check exchange status
- Verify API keys (if using real trading)
- Check rate limits

## Support

- Hummingbot Docs: https://hummingbot.org
- Hummingbot Discord: https://discord.gg/hummingbot
- Railway Docs: https://docs.railway.app

## License

Apache 2.0 - Same as Hummingbot
