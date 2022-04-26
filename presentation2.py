#!/usr/bin/env python3

import socket
import struct
import sys


def main():
    server_ip = "54.148.163.48"
    port = 3456
    server_address = (server_ip, port)

    # Create UDP socket
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # Generate request
    protocol_version_num = 1
    a = 30
    b = 60
    name = "Dean Shin"

    request_bytes = struct.pack(
        ">biii",
        protocol_version_num,
        a,
        b,
        len(name)
    ) + bytes(name, "ascii")

    # Send request message to server
    s.sendto(request_bytes, server_address)

    # Receive response from server
    raw_bytes, rec_address = s.recvfrom(4096)

    # Close socket
    s.close()

    # Decode response from server
    rec_protocol_version_num, status_code, total_sum = struct.unpack("!BHI", raw_bytes)
    if status_code != 1:
        print("Failure\n")
    else:
        print(f"{a}+{b}={total_sum}")


if __name__ == "__main__":
    sys.exit(main())