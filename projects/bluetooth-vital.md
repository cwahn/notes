# Bluetooth Vital Dev
- [Bluetooth Vital Dev](#bluetooth-vital-dev)
  - [Environment Setup](#environment-setup)
    - [PlatformIO](#platformio)
      - [Installation](#installation)
      - [Change Default Project Dir](#change-default-project-dir)
      - [Chardet Error](#chardet-error)
      - [New Project](#new-project)
      - [Issues](#issues)
  - [IO](#io)
    - [Bluetooth Low Energy](#bluetooth-low-energy)
      - [Protocol Stack](#protocol-stack)
        - [PHY](#phy)
        - [LL](#ll)
        - [GAP](#gap)
        - [GATT](#gatt)
        - [ATT](#att)
        - [Profile](#profile)
    - [Implementation](#implementation)
  - [References](#references)

## Environment Setup
[PlatformIO](https://platformio.org) seems good for IDE. 

### PlatformIO
#### Installation 
Search PlatformIO at VSCode extension and install.

#### Change Default Project Dir
Use the command below in pio CLI
```
pio settings set projects_dir <DIR_PATH>
```

#### Chardet Error
If it fails to compile the ESP-IDF project manually install the package.
```
source /Users/chanwooahn/.platformio/penv/.espidf-5.0.2/bin/activate
pip install chardet   
```

#### New Project
A new project is to be started that platformIO home in VSCode. Will set up default directories structure and CMakeLists.

One could activate a project by opening a project directory with VS code.

#### Issues
- Error on initial build; 
  ```
  fatal: not a git repository (or any of the parent directories): .git
  ``` 
  - Does it have to be .git repository?
Maybe the message below is relevent.
    ```
    ModuleNotFoundError: No module named 'chardet'
    ```
- Error not finding `esp_bt.h`
  - Run manuconfig with pio and enable bluetooth
    ```
    pio run -t menuconfig
    ```
- Formatting related error
  - Maybe relevent [issue](https://github.com/espressif/esp-idf/issues/9511)
    - Sugggest to silence the warning 
        ```
        // CMakeLists.txt
        component_compile_options(-Wno-error=format= -Wno-format)
        ``` 
- Upload port does not exist error
  - Specify upload port manually at `platformio.ini`.
    ```
    upload_port = /dev//dev/cu.SLAB_USBtoUART
    ```
- C++ STL library linkage error
  - Default main file is C, not C++. Need to change file with 
  - Also need extern C
  ```
  #ifdef __cplusplus
    extern "C"
    {
    #endif

        constexpr char *main_tag = "app_main";

        void app_main(void)
        {
            ...
        }

    #ifdef __cplusplus
    }
    #endif      
  ```

- When one need to pass function pointer for callback or anything else, It should be static free function or static member function. 

- Use `static` at declaration, do not at definition.

- Things might need to be static, but not constant. Mutate the static value to wrap things as class.

## IO
### Bluetooth Low Energy 
Bluetooth low energy. [^1]     

#### Protocol Stack
- App
- Host
  - GAP(General Access Profile), GATT(General Attribute Protocol)
  - SMP(Security Manager), ATT(Attribute Protocol)
  - L2CAP(Logical Link Control & Adaption Protocol)
- Controller
  - LL(Link Layer)
  - PHY(Physical Layer)
  
##### PHY
40 2.4 GHz channels. 3 for advertising, 37 for data.

##### LL
Have 5 state
- Standby
  - No communication
- Advertising
  - Sending advertizement packet, can receive response to it, Or send response to others
- Scanning
  - Scanning the advertizement channels
- Initial
  - After receving connectable advertizing packet, connection request has been sent and waiting for connection 
- Connection
  - Connection made

##### GAP
GAP constrols advertising and connection. GAP defines the way a device is displayed to other devices and making connection.

GAP have cetral-prepheral model and broadcaster-observer model. 1:1 connection is cetral-prepheral model. 

GAP advertising packet includes advertising-data-payload and optional scan-data-payload. Maximum 31 Bytes

Peripheral device sends advertising packet every advertising interval. If a central device descovered the advertising packet, and also interested in scan response data, the central device could request the scan response data and peripheral device will respond. This is called boadcasting.

Devices only do boroadcaseing is beacon.

Once devices are connected, advertising is terminated and no ather device can discover the peripheral device. After connection, devices will communicate according to the defined service and characteristic. 

##### GATT
GATT defines the data model and protocol. GATT defines profile, services and characteristics. Including what is the data, r/w/notification permission, etc.

```
profile :: Set service
service :: Set characteristic
characteristic :: (UUID, ...)
```

There are standard services and custom services. Standard services have 16 bits UUID, and custom services have 128 bits UUID.

There are standard characteristics and custom characteristics. Predifined services does have some essential involved characteristics.

After the connection, the central becomes GATT client (the one aquire the data) and connects to GATT server (the one produce data).

Descripter describes a characteristic.

##### ATT
GATT is upper most implementation of ATT and often refered as GATT/ATT. Attribute defines services and characteristics.

##### Profile
Set of services. Predefined standard services have some essential services. And custom services could be added.

### Implementation

- ESP-IDF ble_spp_client
  - Keep scanning the counter part

- ESP-IDF ble_spp_client
  - Does not work with error on start up
    ```
    I (0) cpu_start: App cpu up.
    I (455) heap_init: Initializing. RAM available for dynamic allocation:
    I (462) heap_init: At 3FFAFF10 len 000000F0 (0 KiB): DRAM
    I (468) heap_init: At 3FFB6388 len 00001C78 (7 KiB): DRAM
    I (474) heap_init: At 3FFB9A20 len 00004108 (16 KiB): DRAM
    I (480) heap_init: At 3FFC8E78 len 00017188 (92 KiB): DRAM
    I (486) heap_init: At 3FFE0440 len 00003AE0 (14 KiB): D/IRAM
    I (492) heap_init: At 3FFE4350 len 0001BCB0 (111 KiB): D/IRAM
    I (499) heap_init: At 40095B1C len 0000A4E4 (41 KiB): IRAM
    I (505) cpu_start: Pro cpu start user code
    I (523) spi_flash: detected chip: generic
    I (524) spi_flash: flash io: dio
    W (524) spi_flash: Detected size(4096k) larger than the size in the binary image header(2048k). Using the size in the binary image header.
    I (535) cpu_start: Starting scheduler on PRO CPU.
    I (0) cpu_start: Starting scheduler on APP CPU.
    I (565) BTDM_INIT: BT controller compile version [ad2b7cd]
    I (565) system_api: Base MAC address is not set
    I (565) system_api: read default base MAC address from EFUSE
    I (575) phy_init: phy_version 4670,719f9f6,Feb 18 2021,17:07:07
    I (1045) gatt_event: ESP_GATTS_REG_EVT
    I (1055) gatt_event: ESP_GATTS_REG_EVT
    W (1055) BT_BTM: BTM_BleWriteAdvData, Partial data write into ADV
    I (1065) gatt_event: ESP_GATTS_CREAT_ATTR_TAB_EVT
    I (1065) HID_LE_PRF: esp_hidd_prf_cb_hdl(), start added the hid service to the stack database. incl_handle = 40
    I (1075) gap event: ESP_GAP_BLE_ADV_DATA_SET_COMPLETE_EVT
    I (1085) gatt_event: ESP_GATTS_CREAT_ATTR_TAB_EVT
    I (1085) HID_LE_PRF: hid svc handle = 2d
    I (1085) gatt_event: ESP_GATTS_START_EVT
    I (1105) gap event: ESP_GAP_BLE_ADV_START_COMPLETE_EVT
    I (1105) gatt_event: ESP_GATTS_START_EVT
    I (18065) gatt_event: ESP_GATTS_CONNECT_EVT
    I (18065) gatt_event: ESP_GATTS_CONNECT_EVT
    I (18065) HID_LE_PRF: HID connection establish, conn_id = 0
    I (18075) HID_DEMO: ESP_HIDD_EVENT_BLE_CONNECT
    I (18155) gatt_event: ESP_GATTS_MTU_EVT
    I (18155) gatt_event: ESP_GATTS_MTU_EVT
    I (18695) gatt_event: ESP_GATTS_READ_EVT
    I (18815) gatt_event: ESP_GATTS_READ_EVT
    I (19235) gatt_event: ESP_GATTS_READ_EVT
    I (19295) gatt_event: ESP_GATTS_READ_EVT
    I (19355) gatt_event: ESP_GATTS_READ_EVT
    I (19415) gatt_event: ESP_GATTS_READ_EVT
    I (19475) gatt_event: ESP_GATTS_READ_EVT
    I (19535) gatt_event: ESP_GATTS_WRITE_EVT
    I (19595) gatt_event: ESP_GATTS_WRITE_EVT
    E (19655) BT_GATT: gatts_write_attr_perm_check - GATT_INSUF_ENCRYPTION
    I (24225) gap event: ESP_GAP_BLE_KEY_EVT
    I (24225) gap event: ESP_GAP_BLE_KEY_EVT
    I (24385) gap event: ESP_GAP_BLE_KEY_EVT
    I (24385) gap event: ESP_GAP_BLE_KEY_EVT
    I (24475) gap event: ESP_GAP_BLE_AUTH_CMPL_EVT
    I (24475) HID_DEMO: remote BD_ADDR: 6e2a646ce0ca
    I (24475) HID_DEMO: address type = 1
    I (24485) HID_DEMO: pair status = success
    I (24485) gatt_event: ESP_GATTS_WRITE_EVT
    I (24695) gatt_event: ESP_GATTS_WRITE_EVT
    I (24755) gap event: ESP_GAP_BLE_UPDATE_CONN_PARAMS_EVT
    I (24755) gatt_event: ESP_GATTS_READ_EVT
    I (26055) HID_DEMO: Send the volume
    I (26055) gatt_event: ESP_GATTS_CONF_EVT
    ```

- Arduino SerialToSerialBT 
  - Does not recognized by either phone and computer. 

- ble_hid_device_demo
  - The most stable implementation so far. 
  - Do code review.
  - This [article](https://github.com/espressif/esp-idf/blob/master/examples/bluetooth/bluedroid/ble/gatt_server/tutorial/Gatt_Server_Example_Walkthrough.md) is also relevent 

- Clean up to single gatt profile version
  - Origial
    - Core logic : `hidd_event_callback` connection, disconnection etc.
    - `hidd_le_env.hidd_cb` is holding `hidd_event_callback`.
    - On the other hand, the actual gatt callback registed with idf api `esp_ble_gatts_register_callback`, is another global function, `gatts_event_handler`. It does react to initial event by it self, but not that important. Major function is dispatch the event by matching suitable profile in profile table `heart_rate_profile_tab`, which is un necesaary.
    - `heart_rate_profile_tab` is a global array holding profiles. profile is basically, tuple of gatt interface and callback function. The instance is holding only one memeber with callback function named `esp_hidd_prf_cb_hdl`.
    - `esp_hidd_prf_cb_hdl` is another global function referencing `hidd_le_env.hidd_cb`, the global variable mentioned earlier. The function create service by calling idf api `esp_ble_gatts_create_attr_tab` with `gatt_if`. Do something on battery event as well. Deligate writing event to `hidd_le_env.hidd_cb`. On attribute table create event, `esp_ble_gatts_create_attr_tab` and `esp_ble_gatts_start_service` apis are called. Also setting some global variable `hid_rpt_map`. 
  - Cleaned up version
    - There should be no table. Make `esp_hidd_prf_cb_hdl` or semilar function deal with the default logic, and have `hidd_event_callback` do the rest. or just make them one. Maybe not one. there could be some initial setup needed by application. 
    - Steady state output is done by `esp_ble_gatts_send_indicate`. It requires `gatts_if`, `conn_id`, `p_rpt->handle`, `length`, `data`, `false`, the last is need_confirm. Hanlde is attribute handle `uint16_t attr_handle`. 
      - `gatts_if`: Aquired from initial gatt event.
      - 'conn_id': Get 
      - WTF handle, length, data.
    - When did it actually sends out name, and profile?
      - `hidd_event_callback` on `ESP_HIDD_EVENT_REG_FINISH` registered by `esp_ble_gap_set_device_name(HIDD_DEVICE_NAME)`, `esp_ble_gap_config_adv_data(&hidd_adv_data)`. The original event is done at `ESP_GATTS_REG_EVT`.
    - Event is first handled by `gatts_event_handler` and `esp_hidd_prf_cb_hdl` and `hidd_event_callback`
    - Events are
      - ESP_GATTS_REG_EVT
        - Initial event. Save interface and connection id.
        - `esp_ble_gap_config_local_icon()` to set icon
        - `esp_ble_gatts_create_attr_tab()` with LONG predifined attribute. Which holds data of service and characteristics. 
      - ESP_BAT_EVENT_REG
        - Do nothing
      - ESP_HIDD_EVENT_BLE_CONNECT
        - Log and save connection id
      - ESP_HIDD_EVENT_BLE_DISCONNECT
        - sec_conn false
        - Log
        - `esp_ble_gap_start_advertising(&hidd_adv_params);` Restart advertising
      - ESP_HIDD_EVENT_BLE_VENDOR_REPORT_WRITE_EVT
        - Log
      - ESP_HIDD_EVENT_BLE_LED_REPORT_WRITE_EVT
        - Log
      - ESP_GATTS_CONF_EVT
        - None
      - ESP_GATTS_CREATE_EVT
        - None
      - ESP_GATTS_CONNECT_EVT
        - `memcpy(cb_param.connect.remote_bda, param->connect.remote_bda, sizeof(esp_bd_addr_t));` Save bda
        - `cb_param.connect.conn_id = param->connect.conn_id;` Save connection Id
        - `hidd_clcb_alloc(param->connect.conn_id, param->connect.remote_bda);` Not sure what this is
        - `esp_ble_set_encryption(param->connect.remote_bda, ESP_BLE_SEC_ENCRYPT_NO_MITM);` Use gap ble api as is.
      - ESP_GATTS_DISCONNECT_EVT
        - `hidd_clcb_dealloc(param->disconnect.conn_id);` Not sure what this is
      - ESP_GATTS_CLOSE_EVT
        - Do noting
      - ESP_GATTS_WRITE_EVT
        - Calls another event, `ESP_HIDD_EVENT_BLE_LED_REPORT_WRITE_EVT`
      - ESP_GATTS_CREAT_ATTR_TAB_EVT
        - Verify `param->add_attr_tab.` data
        - Save service handles
        - Log
        - `esp_ble_gatts_create_attr_tab(hidd_le_gatt_db, gatts_if, HIDD_LE_IDX_NB, 0);` Main attr_tab
        - Fill up `hid_add_id_tbl` Not sure what it is 
        - `esp_ble_gatts_start_service(hidd_le_env.hidd_inst.att_tbl[HIDD_LE_IDX_SVC]);` start service
- Event debugging
  ```
    I (0) cpu_start: App cpu up.
    I (455) heap_init: Initializing. RAM available for dynamic allocation:
    I (462) heap_init: At 3FFAFF10 len 000000F0 (0 KiB): DRAM
    I (468) heap_init: At 3FFB6388 len 00001C78 (7 KiB): DRAM
    I (474) heap_init: At 3FFB9A20 len 00004108 (16 KiB): DRAM
    I (480) heap_init: At 3FFC8E78 len 00017188 (92 KiB): DRAM
    I (486) heap_init: At 3FFE0440 len 00003AE0 (14 KiB): D/IRAM
    I (492) heap_init: At 3FFE4350 len 0001BCB0 (111 KiB): D/IRAM
    I (499) heap_init: At 40095B1C len 0000A4E4 (41 KiB): IRAM
    I (505) cpu_start: Pro cpu start user code
    I (523) spi_flash: detected chip: generic
    I (524) spi_flash: flash io: dio
    W (524) spi_flash: Detected size(4096k) larger than the size in the binary image header(2048k). Using the size in the binary image header.
    I (535) cpu_start: Starting scheduler on PRO CPU.
    I (0) cpu_start: Starting scheduler on APP CPU.
    I (565) BTDM_INIT: BT controller compile version [ad2b7cd]
    I (565) system_api: Base MAC address is not set
    I (565) system_api: read default base MAC address from EFUSE
    I (575) phy_init: phy_version 4670,719f9f6,Feb 18 2021,17:07:07
    I (1045) gatt_event: ESP_GATTS_REG_EVT
    I (1055) gatt_event: ESP_GATTS_REG_EVT
    W (1055) BT_BTM: BTM_BleWriteAdvData, Partial data write into ADV
    I (1065) gatt_event: ESP_GATTS_CREAT_ATTR_TAB_EVT
    I (1065) HID_LE_PRF: esp_hidd_prf_cb_hdl(), start added the hid service to the stack database. incl_handle = 40
    I (1075) gap event: ESP_GAP_BLE_ADV_DATA_SET_COMPLETE_EVT
    I (1085) gatt_event: ESP_GATTS_CREAT_ATTR_TAB_EVT
    I (1085) HID_LE_PRF: hid svc handle = 2d
    I (1085) gatt_event: ESP_GATTS_START_EVT
    I (1105) gap event: ESP_GAP_BLE_ADV_START_COMPLETE_EVT
    I (1105) gatt_event: ESP_GATTS_START_EVT
    I (18065) gatt_event: ESP_GATTS_CONNECT_EVT
    I (18065) gatt_event: ESP_GATTS_CONNECT_EVT
    I (18065) HID_LE_PRF: HID connection establish, conn_id = 0
    I (18075) HID_DEMO: ESP_HIDD_EVENT_BLE_CONNECT
    I (18155) gatt_event: ESP_GATTS_MTU_EVT
    I (18155) gatt_event: ESP_GATTS_MTU_EVT
    I (18695) gatt_event: ESP_GATTS_READ_EVT
    I (18815) gatt_event: ESP_GATTS_READ_EVT
    I (19235) gatt_event: ESP_GATTS_READ_EVT
    I (19295) gatt_event: ESP_GATTS_READ_EVT
    I (19355) gatt_event: ESP_GATTS_READ_EVT
    I (19415) gatt_event: ESP_GATTS_READ_EVT
    I (19475) gatt_event: ESP_GATTS_READ_EVT
    I (19535) gatt_event: ESP_GATTS_WRITE_EVT
    I (19595) gatt_event: ESP_GATTS_WRITE_EVT
    E (19655) BT_GATT: gatts_write_attr_perm_check - GATT_INSUF_ENCRYPTION
    I (24225) gap event: ESP_GAP_BLE_KEY_EVT
    I (24225) gap event: ESP_GAP_BLE_KEY_EVT
    I (24385) gap event: ESP_GAP_BLE_KEY_EVT
    I (24385) gap event: ESP_GAP_BLE_KEY_EVT
    I (24475) gap event: ESP_GAP_BLE_AUTH_CMPL_EVT
    I (24475) HID_DEMO: remote BD_ADDR: 6e2a646ce0ca
    I (24475) HID_DEMO: address type = 1
    I (24485) HID_DEMO: pair status = success
    I (24485) gatt_event: ESP_GATTS_WRITE_EVT
    I (24695) gatt_event: ESP_GATTS_WRITE_EVT
    I (24755) gap event: ESP_GAP_BLE_UPDATE_CONN_PARAMS_EVT
    I (24755) gatt_event: ESP_GATTS_READ_EVT
    I (26055) HID_DEMO: Send the volume
    I (26055) gatt_event: ESP_GATTS_CONF_EVT
  ```
  - Events on startup
    - ESP_GATTS_REG_EVT
    - ESP_GATTS_REG_EVT
    - ESP_GATTS_CREAT_ATTR_TAB_EVT
    - ESP_GAP_BLE_ADV_DATA_SET_COMPLETE_EVT
    - ESP_GATTS_START_EVT
    - ESP_GAP_BLE_ADV_START_COMPLETE_EVT
    - ESP_GATTS_START_EVT
The ported version doesn't emit ESP_GATTS_START_EVT.
Actually not responding to it
    - `gatts_profile_event_handler` doing nothing Okay, another source also does nothing on this event, when does it evoke?
    - [Documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/bluetooth/esp_gatts.html?highlight=esp_gatts_start_evt#_CPPv4N20esp_gatts_cb_event_t19ESP_GATTS_START_EVTE) says when starting service is completed
      - What strats service then?
      - Maybe `esp_ble_gatts_start_service` this on `ESP_GATTS_CREAT_ATTR_TAB_EVT`.
  - Okay let's see `ESP_GATTS_REG_EVT` first.
    - [Documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/bluetooth/esp_gatts.html?highlight=esp_gatts_start_evt#_CPPv4N20esp_gatts_cb_event_t19ESP_GATTS_START_EVTE) says when application id is registered. 
    - `ESP_GATTS_REG_EVT` is the first event should be get called.
    - It was because the main application was returning.
    - Main application is returning but the the other processes keep running.
    - Per [this](https://github.com/espressif/esp-idf/blob/master/examples/bluetooth/bluedroid/ble/gatt_server_service_table/tutorial/Gatt_Server_Service_Table_Example_Walkthrough.md) guide, maybe `esp_ble_gatts_app_register(ESP_HEART_RATE_APP_ID);` this call is missing.
        ```
        esp_err_t hidd_status;

        // * How does this setup GATT callback?

        if(callbacks != NULL) {
            hidd_le_env.hidd_cb = callbacks;
        } else {
            return ESP_FAIL;
        }

        // * This function actually register the callback from global variable hidd_le_env
        if((hidd_status = hidd_register_cb()) != ESP_OK) {
            return hidd_status;
        }

        esp_ble_gatts_app_register(BATTRAY_APP_ID);

        if((hidd_status = esp_ble_gatts_app_register(HIDD_APP_ID)) != ESP_OK) {
            return hidd_status;
        }

        return hidd_status;
        ```
    - Okay after the registration of callback function, it does call the `esp_ble_gatts_app_register` function twice.
  - What does `esp_ble_gatts_app_register` actually do?
    - It is an esp-idf api, not application function.
    - Does it has to work with profile table? Which table is the implementation referencing? Why is it passing table index to the external api.
    - Check out the gatt callback function an if the api is application -> Save it at env and call `hidd_le_create_service` with `gatts_if`. If battery, not do much.
    - There might be pre defined app ids.
        ```
        #define HIDD_APP_ID			0x1812//ATT_SVC_HID

        #define BATTRAY_APP_ID       0x180f
        ```
    - Okay, now it works with `esp_ble_gatts_app_register` call.
    - App ids might be user defined value for interal event dispatch.
  - Now the problem is `esp_ble_gatts_create_attr_tab(bas_att_db, gatts_if, BAS_IDX_NB, 0)`.
    - Needs quite extensive data vas_atta_db.
    - What are the other attribute db examples like?
    - A db is an array of `esp_gatts_attr_db_t`.
        ```
        typedef struct
        {
            esp_attr_control_t      attr_control;                   /*!< The attribute control type */
            esp_attr_desc_t         att_desc;                       /*!< The attribute type */
        } esp_gatts_attr_db_t;
        ```
    - Attribute discription is like below;
        ```
        typedef struct
        {  
        uint16_t uuid_length;              /*!< UUID length */
        uint8_t  *uuid_p;                  /*!< UUID value */
        uint16_t perm;                     /*!< Attribute permission */
        uint16_t max_length;               /*!< Maximum length of the element*/
        uint16_t length;                   /*!< Current length of the element*/
        uint8_t  *value;                   /*!< Element value array*/
        } esp_attr_desc_t; 
        ```
    - Each of them represent some data.
    - `{ESP_GATT_AUTO_RSP}` seems default for `esp_attr_control_t      attr_control;`.
    - `ESP_UUID_LEN_16` seems default for `uuid_length`.
    - `uuid_p` should be pointer of a value. Actual values are defined at;
      - `/Users/chanwooahn/esp/esp-idf/components/bt/host/bluedroid/api/include/api/esp_gatt_defs.h`
      - However, they are pointers => need to make instance.
    - `ESP_GATT_PERM_READ` seems default for `perm`.
    - `max_length` and `length` have various value, but often the same 
      - `CHAR_DECLARATION_SIZE` for character declaration.
    - For `value`
      - If there is `ESP_GATT_PERM_WRITE` in `perm` often `NULL`
      - If is character declaration, often on of pointer type conversioned followings;
        ```
        static const uint8_t char_prop_notify = ESP_GATT_CHAR_PROP_BIT_NOTIFY;
        static const uint8_t char_prop_read = ESP_GATT_CHAR_PROP_BIT_READ;
        static const uint8_t char_prop_write_nr = ESP_GATT_CHAR_PROP_BIT_WRITE_NR;
        static const uint8_t char_prop_read_write = ESP_GATT_CHAR_PROP_BIT_WRITE|ESP_GATT_CHAR_PROP_BIT_READ;
        static const uint8_t char_prop_read_notify = ESP_GATT_CHAR_PROP_BIT_READ|ESP_GATT_CHAR_PROP_BIT_NOTIFY;
        static const uint8_t char_prop_read_write_notify = ESP_GATT_CHAR_PROP_BIT_READ|ESP_GATT_CHAR_PROP_BIT_WRITE|ESP_GATT_CHAR_PROP_BIT_NOTIFY;
        static const uint8_t char_prop_read_write_write_nr = ESP_GATT_CHAR_PROP_BIT_READ|ESP_GATT_CHAR_PROP_BIT_WRITE|ESP_GATT_CHAR_PROP_BIT_WRITE_NR;
        ```
    - Service creation
      - HID source did
        - `esp_ble_gap_config_local_icon(ESP_BLE_APPEARANCE_GENERIC_HID);`
        - `esp_ble_gap_set_device_name(HIDD_DEVICE_NAME);`
        - `esp_ble_gap_config_adv_data(&hidd_adv_data);`
        - `hidd_le_create_service(hidd_le_env.gatt_if);`
          - `esp_ble_gatts_create_attr_tab(bas_att_db, gatts_if, BAS_IDX_NB, 0);`
      - Another sourece did
        - `esp_ble_gap_set_device_name(TEST_DEVICE_NAME);`
        - `esp_ble_gap_config_adv_data(&adv_data);`
        - `esp_ble_gap_config_adv_data(&scan_rsp_data)` (scan data)
        - `esp_ble_gatts_create_service(gatts_if, &gl_profile_tab[PROFILE_A_APP_ID].service_id, GATTS_NUM_HANDLE_TEST_A);`
      - Seems like `esp_ble_gatts_create_attr_tab` could be used instead of `esp_ble_gatts_create_service` and vice versa
    - Why some entry has decalaration and value, and some does not?
      - ???
  - Now handle `ESP_GATTS_CONNECT_EVT`
  - `E (13377) BT_APPL: earlier enc was not done for same device` after connection.
    - Seems the error is related with global variable `bta_dm_cb`.
    - But sometimes it does not happen.
    - ???
  - How did hfp works? Does client read all the data from device by polling? Or does device was sending notification?
    - ???
  - Data rate?
    - Seems good. let's test.
  - How does the source code works?
    - Works only for sound device.
    - Need generic.
    - [OpenBLE](https://github.com/OpenBluetoothToolbox/SimpleBLE/tree/main) seems useful.
  - What is the bluetooth device address?
    - Id for bluetooth device.
    - But what exactly is the device? Is it physical or logical?
    - It is 48 bits, 6 Bytes id. First half is OUI(Organized Unique Identifier) which is assined by IEEE. The second half is LAP(Lower Address Part) which is given by vender.
      - For ESP32, there is predefined value. It could be checked with ` esp_bt_dev_get_address()`.
  - What is the attribute handle for the read event?
    - It coule be service handle or characteristic handle.
    - The function get called when one tries to create service? (Or application maybe) has signature like below; `esp_err_t esp_ble_gatts_create_attr_tab(const esp_gatts_attr_db_t * gatts_attr_db, esp_gatt_if_t gatts_if, uint16_t max_nb_attr, uint8_t srvc_inst_id)`
    - The parameter `max_nb_attr` is the length of the table or the array.
    - The table or array containes services and charteristics (declaration, definition).
    - The table itself is more like a service rather than profile.
  - Check the definitions again.
    - There is a profile table, which is a list of profile instance.
      - `ProfileTable :: [ProfileInstance]`
    - Profile instace is consists of callback function, gatt interface, app id, connection id. This is not ESP-IDF specified structure.
      - `ProfileInstance :: (GattCallback, GattInterface, AppId, ConnectionId)`
      - Which implies that profile instance ~ app (profile)
      - Actually, the gatt event parameter has member named app id. 
    - A Callback function is ESP-IDF defined function with certain signature.
      - `GattCallback :: (esp_gatts_cb_event_t, esp_gatt_if_t, esp_ble_gatts_cb_param_t) -> void`
    - How does the table realated with Application profile list, or profile instance?
      - `esp_ble_gatts_create_attr_tab` could be used instead of `esp_ble_gatts_create_service` and vice versa. 
        - Impliese an attribute table represent a service.
      - Creation of attribute table invokes `ESP_GATTS_CREAT_ATTR_TAB_EVT` event.
      - Not sure why but `esp_ble_gatts_create_attr_tab` are called with the same `srvc_inst_id`, 0;
      - `esp_err_t esp_ble_gatts_start_service(uint16_t service_handle)` takes service handle. In the example this is the first index of attribute db. 
      - When a event comes in. It will dispatched by the gatt interface.
        - Profiles are stored in the profile table.
        - Each ProfileInstance has connected gatt interface.
        - Compare this interface to determine if the call back is get called or not.
      - When does the interface get attatched?
        - On `ESP_GATTS_REG_EVT`.
      - So right after the configuration, the global and common gap and gatt callback functions are registered. However, these things are not the actual starting point.
        - The actual starting point is the initial service registration with `esp_err_t esp_ble_gatts_app_register(uint16_t app_id)`. At this point, the Profile table already exists. Application id is also registered id is also installed at profile instance.
        - It will envoke `ESP_GATTS_REG_EVT`. While handling this event, call `esp_ble_gatts_create_attr_tab(battery_service_attribute_db, gatts_if, BAS_IDX_NB, 0);` with the db in accordance. However, the attribute db is not a member of the profile instance. So this will be the point actually they are associated. 
      - Okay so I believe a profile instance should also hold attribute db as well.
        - How about other implementations?
          - Walkthrough also does have db inside the profile instance.
        - Does this application id even visible to clients? It seems it does not have to hold its own identifier.
      - Source code review
        - `esp_err_t esp_ble_gatts_create_service(esp_gatt_if_t gatts_if,
        esp_gatt_srvc_id_t *service_id, uint16_t num_handle);` has to be called first and it will produce application id.
    - How to pass a non-static function to reference.
      - This is the way how!
        ```
        #include <iostream>

        using LambdaFunction = void(*)(int);

        static LambdaFunction lambdaFunction = nullptr;

        void staticFunction() {
            
            if (lambdaFunction) {
                lambdaFunction(42);  // Call the lambda function if it is set
            }else{
                std::cout << "Nil" << std::endl;
            }
        }

        int main() {
            staticFunction();  // Nil

            lambdaFunction = [](int x) {
                std::cout << x << std::endl;
            };
            
            staticFunction();  // 42

            return 0;
        }
        ```
      - it only works for non-capturing lambdas. [Here](https://stackoverflow.com/questions/7852101/c-lambda-with-captures-as-a-function-pointer) is the version works for capturing lambdas.
        ```
        #include <iostream>
        #include <vector>

        struct Lambda {
            template<typename Tret, typename T>
            static Tret lambda_ptr_exec(void* data) {
                return (Tret) (*(T*)fn<T>())(data);
            }

            template<typename Tret = void, typename Tfp = Tret(*)(void*), typename T>
            static Tfp ptr(T& t) {
                fn<T>(&t);
                return (Tfp) lambda_ptr_exec<Tret, T>;
            }

            template<typename T>
            static void* fn(void* new_fn = nullptr) {
                static void* fn;
                if (new_fn != nullptr)
                    fn = new_fn;
                return fn;
            }
        };

        static void(*inner_function)(void *)  = nullptr;

        static void outer_function()
        {
            if (inner_function != nullptr)
            {
                inner_function(nullptr);
            }
        }


        int main() {

            int a = 100;
            auto b = [&](void*) {return ++a;};
            
            void (*f1)(void*) = Lambda::ptr(b);
            f1(nullptr);
            printf("%d\n", a);  // 101 
            
            outer_function();
            printf("%d\n", a);  // 101 
            
            inner_function = Lambda::ptr(b);
            
            outer_function();
            printf("%d\n", a);  // 102
            
            return 0;
        }
        ```
    - This is the way how it works for no argument function.
    - Okay, now per [this](https://github.com/espressif/esp-idf/issues/11900#issuecomment-1641397325) answer, it seems quite sure that there is no one idiomatic way of doing this. 
    - Let's wrap this up.
      - On initialization of Ble or an IO including this IO should return IO object. Input should be a stream and output should be an object taking variant as input. 
      - The input type should be a variant of; 
        - `()` (initialization)
        - `(esp_gap_ble_cb_event_t event, esp_ble_gap_cb_param_t *param)` (gap call)
        - `esp_gatts_cb_event_t event, esp_gatt_if_t gatts_if, esp_ble_gatts_cb_param_t *param` (gatt callback)
      - The output type should be a variant of;
        - However variant might not be available in some barebone, no-STL environments.
        - Should I go with a tagged union?
      - This time go with the official reference structure.
        - If the constructor take a list of profiles I the default gap and gatt call_back function could be built. 
        - Also, if it takes two gap callback and gatt callback function, They could be get called after the default callback. 
        - This call back could reference external state although It seems not healthy, lets go this way for now. Also, other functions may call the ble output. which seems also not healthy, but let's go this way,,,, right?
      - At which point the current profile is set and saved?
        - Per the official guide, a profile should hold the information of connection id and gatts_if.
        - Connection id is captured at `ESP_HIDD_EVENT_BLE_CONNECT`.
          - Which is essentially `ESP_GATTS_CONNECT_EVT`, with a value of `param->connect.conn_id`.
        - Gatts interface is captured at `ESP_GATTS_REG_EVT`.
          - As `gatts_if`.
      - There has to be a list of (gatt_if, conn_id) with the length of profiles.
        - Which could be StaticArray.


  - Incremental numbers
    - What should be the service and characteristic for this task?
    - Predefined UUIDs by Bluetooth standards are [here](https://btprodspecificationrefs.blob.core.windows.net/assigned-numbers/Assigned%20Number%20Types/Assigned_Numbers.pdf).
    - [This](https://novelbits.io/bluetooth-gatt-services-characteristics/) guide is also helpful for  GATT design.
    - The way how to enable BLE long read with ESP-IDF BLE stack is [here](https://sankalpb.github.io/bluetooth-lowenergy/embedded/2019/03/15/BLE-long-read-on-esp32.html).
    - How could I generate a custom service and characteristic?
      - When one creates a custom service or characteristic, it will show up on the client device as an unknown service / characteristic per [this](https://esp32.com/viewtopic.php?t=12855) comment.
    - 


  - Number buffer
    - WIP


## References
[^1] https://embeddedcentric.com/introduction-to-bluetooth-low-energy-bluetooth-5/