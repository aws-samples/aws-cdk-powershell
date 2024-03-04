FROM alpine:3.19
WORKDIR /app

# To build an image
# docker build -t IMAGE_NAME .

# To interact with a docker container locally to use the AWS.CDK.PowerShell module
# docker run -e AWS_ACCESS_KEY_ID='YOUR_ACCESS_KEY' -e AWS_SECRET_ACCESS_KEY='YOUR_SECRET_ACCESS_KEY' -e AWS_DEFAULT_REGION='YOUR_REGION' --entrypoint /usr/bin/pwsh -it IMAGE_NAME

############################################
# Installing prerequisites

###########################
# bash
# Bash is needed for dotnet install script
RUN apk add --no-cache --upgrade bash
###########################

###########################
# mono
RUN apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add --no-cache --virtual=.build-dependencies ca-certificates && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    apk del .build-dependencies
###########################

###########################
# Install dotnet8
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
RUN chmod +x ./dotnet-install.sh
RUN bash ./dotnet-install.sh --channel 8.0
###########################

###########################
# Install powershell core 7.3
# https://learn.microsoft.com/en-us/powershell/scripting/install/install-alpine?view=powershell-7.4#installation-steps
# install the requirements
RUN apk add --no-cache \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    # libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    curl

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
    lttng-ust

# Download the powershell '.tar.gz' archive
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell-7.4.1-linux-musl-x64.tar.gz -o /tmp/powershell.tar.gz

# Create the target folder where powershell will be placed
RUN mkdir -p /opt/microsoft/powershell/7

# Expand powershell to the target folder
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

# Set execute permissions
RUN chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
###########################

###########################
# npm
RUN apk add --update nodejs npm
RUN apk add --update npm
###########################

###########################
# cdk
RUN npm install -g aws-cdk@2.131.0 
###########################

###########################
# nuget
# Download the latest stable `nuget.exe` to `/usr/local/bin`
RUN curl -o /usr/local/bin/nuget.exe https://dist.nuget.org/win-x86-commandline/latest/nuget.exe

# Create as alias for nuget
RUN alias nuget="mono /usr/local/bin/nuget.exe"
###########################
############################################

############################################
# Create a folder for modules 
RUN mkdir -p /usr/local/share/powershell/Modules
RUN mkdir -p /usr/local/share/powershell/Modules/AWS.CDK.PowerShell
############################################

############################################
# Copy the module
COPY AWS.CDK.PowerShell /usr/local/share/powershell/Modules/AWS.CDK.PowerShell
############################################

ENTRYPOINT ["pwsh"]