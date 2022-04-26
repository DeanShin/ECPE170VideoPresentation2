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
    # Bind to server
    s.bind(("127.0.0.1", 8000))

    # Generate request
    protocol_version_num = 1
    a = 49
    b = 51
    name = bytes("Dean Shin", "ascii")
    chars_in_name = len(name)

    request_bytes = struct.pack(
        ">biiis",
        protocol_version_num,
        a,
        b,
        chars_in_name,
        name
    )

    print("Requesting...")
    # Send request message to server
    s.sendto(request_bytes, server_address)
    print("Request complete!")

    print("Waiting for response...")
    # Receive response from server
    raw_bytes, rec_address = s.recvfrom(1024)
    print("Response received!")

    # Close socket
    s.close()

    # Decode response from server
    rec_protocol_version_num, status_code, total_sum = struct.unpack(">chi", raw_bytes)
    if status_code != 200:
        print("Failure\n")
    else:
        print("Success\n")
        print(f"{a}+{b}={total_sum}\n")


if __name__ == "__main__":
    sys.exit(main())