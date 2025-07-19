#!/bin/bash


# certifica-se de que está definido como o diretório home do usuário atual:
LOCAL_HOME="$(eval echo ~)"

LOG="/tmp/btman.log"
BLUE_SCRIPT="$LOCAL_HOME/bin/blue.sh"

if [[ ! -x "$BLUE_SCRIPT" ]]; then
  echo "Script $BLUE_SCRIPT não encontrado ou não executável." | tee "$LOG"
  exit 1
fi

{

  echo " "
  echo " "
  echo "Data e hora atual: $(date)"
  echo " "
  echo "### Gerenciando dispositivos Bluetooth de Áudio ###"
  echo "---"

  echo "1. Listando e filtrando dispositivos Bluetooth de áudio..."
  mapfile -t BLUEZ_DEVICES < <("$BLUE_SCRIPT" -list | grep "^bluez")

  if [[ ${#BLUEZ_DEVICES[@]} -eq 0 ]]; then
    echo "Nenhum dispositivo 'bluez' encontrado. Verifique se estão pareados e ligados."
    echo "---"
    exit 0
  fi

  echo "Dispositivos 'bluez' encontrados:"
  printf '%s\n' "${BLUEZ_DEVICES[@]}"
  echo "---"

  for DEVICE_NAME in "${BLUEZ_DEVICES[@]}"; do
    echo "2. Processando dispositivo: '$DEVICE_NAME'"
    echo "---"

    ACTIVE_PROFILE=$("$BLUE_SCRIPT" -active "$DEVICE_NAME")
    echo "   Perfil Ativo: $ACTIVE_PROFILE"

    echo "   Perfis Disponíveis:"
    while IFS= read -r profile; do
      echo "     - $profile"
      if [[ "$profile" != "$ACTIVE_PROFILE" ]]; then
        pactl set-card-profile "$DEVICE_NAME" "$profile"
      fi
    done < <("$BLUE_SCRIPT" "$DEVICE_NAME")

    echo "   Confirmado Perfil Ativo: $ACTIVE_PROFILE"
    echo "---"
    pactl set-card-profile "$DEVICE_NAME" a2dp-sink 
  done

  echo "### Processamento Concluído ###"
} >> "$LOG" 2>&1