#!/bin/bash
clear

export jwt_secret="jwt_secret"
export jwt_issuer="jwt_issuer"
export jwt_audience="jwt_audience"
export jwt_realm="jwt_realm"

declare -A services=(
    ["api_gateway"]=8050
    ["service_chat"]=8051
    ["service_identity"]=8052
    ["service_location"]=8053
    ["service_notification"]=8054
    ["service_restaurant"]=8055
    ["service_taxi"]=8056
)

# 1️⃣ Verificar si la red existe, si no, crearla
docker network create traefik_net 2>/dev/null || true

# 2️⃣ Verificar si Traefik ya está corriendo
if ! docker ps --format "{{.Names}}" | grep -q "traefik"; then
    echo "🚀 Iniciando Traefik..."
    docker run -d --name traefik \
      --network=traefik_net \
      -p 80:80 \
      traefik:v2.10 \
      --entrypoints.web.address=:80
else
    echo "✅ Traefik ya está corriendo."
fi

# 3️⃣ Buscar los servicios y levantarlos
find . -type f -name "Dockerfile" | while read dockerfile; do
    dir=$(dirname "$dockerfile")
    image=$(basename "$dir")

    if [[ -n "${services[$image]}" ]]; then
        port=${services[$image]}

        echo "📦 Building image: $image"
        docker build -t "$image" "$dir"

        echo "🚀 Running $image on port $port"

        docker run --rm -d \
            --network=traefik_net \
            --name $image \
            -p "$port:$port" \
            --label "traefik.enable=true" \
            --label "traefik.http.routers.$image.rule=PathPrefix('/$image')" \
            --label "traefik.http.services.$image.loadbalancer.server.port=$port" \
            --env=jwt_secret=$jwt_secret \
            --env=jwt_issuer=$jwt_issuer \
            --env=jwt_audience=$jwt_audience \
            --env=jwt_realm=$jwt_realm \
            --env=port=$port \
            "$image"
    fi
done
