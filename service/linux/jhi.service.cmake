[Unit]
Description=Intel Dynamic Application Loader Host Interface (JHI)

[Service]
Type=notify
ExecStart=${CMAKE_INSTALL_PREFIX}/sbin/jhid
Restart=on-abort

[Install]
WantedBy=multi-user.target