mkdir pki && cd pki

# CA
openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650   -subj "/CN=Lab Internal CA"   -addext "basicConstraints=critical,CA:TRUE"   -addext "keyUsage=critical,keyCertSign,cRLSign" -out ca.crt

issue() {  # $1=basename  $2=CN  $3=SANs  $4=EKU
  openssl genrsa -out $1.key 2048
  openssl req -new -key $1.key -subj "/CN=$2" -out $1.csr
  openssl x509 -req -in $1.csr -CA ca.crt -CAkey ca.key -CAcreateserial -days 825 -sha256 -out $1.crt -extfile <(printf "basicConstraints=CA:FALSE\nkeyUsage=digitalSignature,keyEncipherment\nsubjectAltName=%s\nextendedKeyUsage=%s\n" "$3" "$4")
}

# Frontend cert (clients -> NGINX IC)
issue wildcard     "*.example.net"        "DNS:*.example.net,DNS:example.net"  serverAuth
# Client cert NGINX IC presents to backends
issue nginx-client "nginx-ingress-client" "DNS:nginx-ingress-client"           clientAuth
# Backend server certs (install these on the backends)
issue web1 "web1.example.net" "DNS:web1.example.net,IP:10.0.24.24" serverAuth
issue web2 "web2.example.net" "DNS:web2.example.net,IP:10.0.24.28" serverAuth
