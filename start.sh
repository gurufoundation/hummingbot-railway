#!/bin/bash

echo "========================================"
echo "HUMMINGBOT RAILWAY DEPLOYMENT"
echo "========================================"
echo ""

# Set environment variables
export PAPER_TRADE_ENABLED=${PAPER_TRADE:-"true"}
export STRATEGY_NAME=${STRATEGY:-"pure_market_making"}

echo "Configuration:"
echo "- Paper Trading: $PAPER_TRADE_ENABLED"
echo "- Strategy: $STRATEGY_NAME"
echo ""

# Create necessary directories
mkdir -p /home/hummingbot/conf /home/hummingbot/logs /home/hummingbot/data /home/hummingbot/scripts

# If conf files don't exist, create default paper trading config
if [ ! -f /home/hummingbot/conf/conf_client.yml ]; then
    echo "Creating default configuration..."
    
    # Create basic client config
    cat > /home/hummingbot/conf/conf_client.yml <<EOF
instance_id: hummingbot_railway
log_level: INFO
debug_console: false
strategy_report_interval: 900.0
logger_override_whitelist:
  - hummingbot.strategy
  - hummingbot.connector
log_file_path: /home/hummingbot/logs
paper_trade:
  paper_trade_enabled: true
  paper_trade_account_balance:
    USDT: 10000.0
    BTC: 0.5
    ETH: 5.0
    SOL: 1000.0
EOF

    echo "✓ Client config created"
fi

# Create paper trading strategy config
if [ ! -f /home/hummingbot/conf/conf_${STRATEGY_NAME}_1.yml ]; then
    echo "Creating $STRATEGY_NAME strategy config..."
    
    case $STRATEGY_NAME in
        "pure_market_making")
            cat > /home/hummingbot/conf/conf_pure_market_making_1.yml <<EOF
strategy: pure_market_making
exchange: binance_paper_trade
market: BTC-USDT
bid_spread: 0.01
ask_spread: 0.01
minimum_spread: -100.0
order_refresh_time: 30.0
order_refresh_tolerance_pct: 0.0
order_amount: 0.01
price_ceiling: -1.0
price_floor: -1.0
moving_average_bid_spread: 1.0
moving_average_ask_spread: 1.0
risk_factor: 1.0
inventory_target_base_pct: 50.0
order_levels: 1
order_level_amount: 0.0
order_level_spread: 1.0
filled_order_delay: 60.0
hanging_orders_enabled: false
hanging_orders_cancel_pct: 0.1
order_optimization_enabled: false
ask_order_optimization_depth: 0.0
bid_order_optimization_depth: 0.0
add_transaction_costs_to_orders: false
price_source: current_market
price_type: mid_price
price_source_custom: null
take_if_crossed: null
price_source_derivative: null
price_source_market: null
fixed_price_source: false
order_override: null
EOF
            ;;
        "arbitrage")
            cat > /home/hummingbot/conf/conf_arbitrage_1.yml <<EOF
strategy: arbitrage
primary_market: binance_paper_trade
secondary_market: kucoin_paper_trade
primary_market_trading_pair: BTC-USDT
secondary_market_trading_pair: BTC-USDT
min_profitability: 0.5
order_amount: 0.01
adjust_order_enabled: true
active_order_refreshing: true
limit_price_buffer_pct: 0.5
convergance_value: 0.01
max_retries: 3
primary_to_secondary_conversion_rate: 1.0
secondary_to_primary_conversion_rate: 1.0
slippage_buffer: 0.05
manual_arbitrage_threshold: 0.0
minimum_profitable_arbitrage: 0.0
EOF
            ;;
        *)
            echo "Unknown strategy: $STRATEGY_NAME, using pure_market_making"
            ;;
    esac
    
    echo "✓ Strategy config created"
fi

# Create SSL certs for Gateway (if needed)
if [ ! -d /home/hummingbot/certs ]; then
    mkdir -p /home/hummingbot/certs
fi

echo ""
echo "========================================"
echo "Starting Hummingbot..."
echo "========================================"
echo ""
echo "Paper trading mode: $PAPER_TRADE_ENABLED"
echo "Strategy: $STRATEGY_NAME"
echo ""
echo "Logs will be available at: /home/hummingbot/logs/"
echo ""

# Start Hummingbot with auto-start strategy if configured
if [ -n "$STRATEGY" ]; then
    echo "Auto-starting strategy: $STRATEGY"
    cd /home/hummingbot
    
    # Create auto-start script
    cat > /home/hummingbot/auto_start.py <<'PYEOF'
import asyncio
import sys
sys.path.insert(0, '/home/hummingbot')

from hummingbot.client.hummingbot_application import HummingbotApplication

async def main():
    hb = HummingbotApplication.main_application()
    await hb.run()

if __name__ == "__main__":
    asyncio.run(main())
PYEOF

    # Run hummingbot
    exec python -m hummingbot.client.hummingbot_application
else
    # Interactive mode (for manual configuration)
    echo "Starting in interactive mode..."
    exec python -m hummingbot.client.hummingbot_application
fi
