#!/bin/bash
pkill cloudflared
sleep 2
nohup cloudflared tunnel --url http://localhost:7860 > /tmp/cloudflared.log 2>&1 &
