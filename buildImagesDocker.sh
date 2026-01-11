#!/bin/bash
#set -e
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


find . -type f -name "Dockerfile" | while read dockerfile; do
    dir=$(dirname "$dockerfile")
    image=$(basename "$dir")
    if [[ -n "${services[$image]}" ]]; then
      port=${services[$image]}

      echo "📦 Building image: $image"
      #echo "Image: $image - Port: $port"

      #output=$(docker build --no-cache -t "$image" "$dir" 2>&1) || {
      #    echo "$output"
      #    exit 1
      #}

      docker build -t "$image" "$dir"
              #--build-arg jwt_secret=$jwt_secret \
              #--build-arg jwt_issuer=$jwt_issuer \
              #--build-arg jwt_audience=$jwt_audience \
              #--build-arg jwt_realm=$jwt_realm \
              #-t "$image" "$dir"

          #port=$((RANDOM % 1000 + 8000))
      echo "🚀 Running $image on port $port"

          #-p $port:8080
      docker run --rm -d -p $port:$port \
              --env=jwt_secret=$jwt_secret \
              --env=jwt_issuer=$jwt_issuer \
              --env=jwt_audience=$jwt_audience \
              --env=jwt_realm=$jwt_realm \
              --env=port=$port \
              $image

    fi

done


#GUIDE
#docker run --hostname=4a4f08f43262
#--env=JAVA_HOME=/opt/java/openjdk
#--volume=/opt/sonarqube/data
#--workdir=/opt/sonarqube
#-p 9000:9000 -p 9092:9092
#--restart=no
#--label='io.k8s.description=SonarQube Community Build is a self-managed, automatic code review tool that systematically helps you deliver Clean Code.'
# --label='io.openshift.min-cpu=400m'
# --runtime=runc -d sonarqube
