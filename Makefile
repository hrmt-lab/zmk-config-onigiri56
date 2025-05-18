CONFIG_DIR = config

SRCS_L = $(shell find $(CONFIG_DIR) -type f ! -name "*_right*")
SRCS_R = $(shell find $(CONFIG_DIR) -type f ! -name "*_left*")

TARGET_L = ../zmk/app/build/left/zephyr/zmk.uf2
TARGET_R = ../zmk/app/build/right/zephyr/zmk.uf2

.PHONY: build clean

build: $(TARGET_L) $(TARGET_R)

$(TARGET_L): $(SRCS_L)
	docker exec -w /workspaces/zmk/app -it $(container_name) west build -d build/left -b seeeduino_xiao_ble -S studio-rpc-usb-uart -- -DSHIELD=onigiri56_left -DZMK_CONFIG="/workspaces/zmk-config/config" -DCONFIG_ZMK_STUDIO=y -DCONFIG_ZMK_STUDIO_LOCKING=n
	docker exec -w /workspaces/zmk/app -it $(container_name) cp build/left/zephyr/zmk.uf2 build/onigiri56_left.uf2

$(TARGET_R): $(SRCS_R)
	docker exec -w /workspaces/zmk/app -it $(container_name) west build -d build/right -b seeeduino_xiao_ble -- -DSHIELD=onigiri56_right -DZMK_CONFIG="/workspaces/zmk-config/config"
	docker exec -w /workspaces/zmk/app -it $(container_name) cp build/right/zephyr/zmk.uf2 build/onigiri56_right.uf2

clean:
	docker exec -it $(container_name) rm -rf /workspaces/zmk/app/build
	docker exec -it $(container_name) rm -rf /root/.cache/zephyr