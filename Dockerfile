FROM debian:bookworm-slim

# Install SteamCMD dependencies, curl and clear apt lists
# https://developer.valvesoftware.com/wiki/SteamCMD#Linux
RUN apt-get update && \ 
	apt-get upgrade -y && \ 
	apt-get install -y curl lib32gcc-s1 && \ 
	rm -rf /var/lib/apt/lists/*

ENV USER=steam
ENV HOME=/home/steam

RUN useradd -m $USER

USER $USER

WORKDIR $HOME

# Create SteamCMD, as well as server and demos directories (to avoid permission issues when mounting volumes / bind mounts)
RUN mkdir -p Steam server demos

WORKDIR $HOME/Steam

# Download and extract SteamCMD
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Update SteamCMD
RUN ./steamcmd.sh +quit

# Fix missing directories and libraries
# https://developer.valvesoftware.com/wiki/Counter-Strike_2/Dedicated_Servers#Linux_2
RUN mkdir -p $HOME/.steam/sdk32 $HOME/.steam/sdk64 \
	&& ln -s $HOME/Steam/linux32/steamclient.so $HOME/.steam/sdk32/ \
	&& ln -s $HOME/Steam/linux64/steamclient.so $HOME/.steam/sdk64/

ENTRYPOINT ["bash", "/home/steam/Steam/steamcmd.sh"]
CMD ["+help", "+quit"]