# Check HTTPS/SSL
echo -e "\n${YELLOW}🔒 SSL/HTTPS${NC}"
curl -k -s https://localhost/health >/dev/null 2>&1
print_status "HTTPS SSL Certificate" $?

curl -I -s http://localhost | grep -q "301\|302" 2>/dev/null
print_status "HTTP -> HTTPS Redirect" $?

openssl s_client -connect localhost:443 -brief 2>/dev/null | grep -q "CONNECTION ESTABLISHED"
print_status "SSL/TLS Handshake" $?
